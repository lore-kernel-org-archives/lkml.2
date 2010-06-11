Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718Ab0FKIo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 04:44:56 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:49820 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab0FKIox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 04:44:53 -0400
From: Yannick Roehlly <yannick.roehlly@free.fr>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH -v2] pci: clear bridge resource size if BIOS assign bad one
Date: Fri, 11 Jun 2010 10:44:42 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-bfs; KDE/4.4.4; x86_64; ; )
Cc: Yinghai Lu <yinghai.lu@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <bug-16009-13546@https.bugzilla.kernel.org/> <4C0ED401.6060800@oracle.com> <201006091730.32724.bjorn.helgaas@hp.com> (sfid-20100610_084512_744266_12745FCD)
In-Reply-To: <201006091730.32724.bjorn.helgaas@hp.com>
Face: =?iso-8859-1?q?iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAGFBMVEXC?=
 =?iso-8859-1?q?uqeIxKzp5sRygG8s=0A?=
 =?iso-8859-1?q?_JiCIaEGZn2iYtHQ2rVJpAAACWElEQVQ4jW3TzW7iMBAAYMtLcl5v2LtrEs6?=
 =?iso-8859-1?q?bOrRXwBN6ZSHj=0A?=
 =?iso-8859-1?q?_XiOKzQtU9PV3xoY2ldZSQPKXmcn4Rygav+NkYHw1NATD02TexxgSmAdVIU?=
 =?iso-8859-1?q?8EH9EjEuwzGFX5=0A?=
 =?iso-8859-1?q?_GJBG+iFBmeGhijgZ9NYNzMIHTpKnC/S3GsZomjWC0/lRGsTYqgxNwIMRQpR?=
 =?iso-8859-1?q?CC2EKhl93MDSV=0A?=
 =?iso-8859-1?q?_h9EY/yqVIIT9F1Aub6k3hmU4TCH4NoFSNqQS91xFBnqqcJpCM4GDGO+59?=
 =?iso-8859-1?q?LeIOMA+iSnxNAGU=0A?=
 =?iso-8859-1?q?_AWFHQi9Av8Q7KDxoWpWdXgKtx/gJlcNTA72PohlxgINGaBN0RS/rzvWjaE?=
 =?iso-8859-1?q?rYuO1y2LsE4GkD=0A?=
 =?iso-8859-1?q?_Zu5xFMVYu61ZInYZZsGUNUgtitMCHkfzsoYEToIxfyx9bBGF/WFMr4cE6?=
 =?iso-8859-1?q?4YgNVeUIy8v7N8d=0A?=
 =?iso-8859-1?q?_g20Gqb9ALlbbAVqC+er4mEDXJS9vXRwBNsLaqltvUypdeg6rZ8BAjwtrA?=
 =?iso-8859-1?q?omi7Hlvzzh0Cdx8=0A?=
 =?iso-8859-1?q?_CxxR9MPI6wgcoQig7TquLoXUWsgH5yrYJIC22qbqS9xT7VZVts3w8kxF6?=
 =?iso-8859-1?q?PgVTRRyZq1Fa0Xl=0A?=
 =?iso-8859-1?q?_AHbxbETBr6yF6fORFE9+AH85n+TIJ1aLpcOjxbASV//mr9fIRVLf9fGYz?=
 =?iso-8859-1?q?r3Id+Uy3M7JPdNK=0A?=
 =?iso-8859-1?q?_XPJFCuv0XXL2/Harkaep2RPDgj6gx+PKZjhzL8C3InW9+4ygDVObKrVK?=
 =?iso-8859-1?q?m6rg6uMHQ9gwqPn2=0A?=
 =?iso-8859-1?q?_TNvZVmr+SpMM55aadaqjhVbO2rZ6uYMi6H5wKgarvkPXIViwCa5TcJTKdg?=
 =?iso-8859-1?q?l2HHG9AeUGl/4J=0A?=
 =?iso-8859-1?q?_UsTl4z2DBUc78QUxZmhVf/wv2J/YT1L9A+9D53ETf4qfAAAAAElFTkS?=
 =?iso-8859-1?q?uQmCC?=
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6dfEMDCb2xH5jNG"
Message-Id: <201006111044.42520.yannick.roehlly@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_6dfEMDCb2xH5jNG
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Le Thursday 10 June 2010 01:30:31 Bjorn Helgaas, vous avez =E9crit :
> On Tuesday, June 08, 2010 05:36:33 pm Yinghai Lu wrote:
> > On 06/08/2010 03:48 PM, Bjorn Helgaas wrote:
> > > On Tuesday, June 08, 2010 03:43:50 pm Jesse Barnes wrote:
> > >=20
> > > In this case, the aperture *size* from the BIOS is actually OK, but
> > > the beginning of the aperture overlaps system memory.  With Yinghai's
> > > patch, we reduce the size and move the start.  Windows was able to
> > > just move the start of the aperture and preserve the original
> > > 0x20000000 size (but I think it had to move something else out of
> > > the way).
> >=20
> > are you sure? that looks more aggressive.
>=20
> I don't have the machine and can't be 100% sure, but based on what
> Yannic reported here:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D16009#c11, it looks like
> Windows moved that aperture.
>=20
> I haven't used it myself, but possibly a program like SIV
> (http://rh-software.com/) would give more detailed information
> about what Windows is doing.

Hi Bjorn,

I don't know if it's useful, but here some output of SIV concerning PCI and=
=20
the Radeon card.

Yannick

--Boundary-00=_6dfEMDCb2xH5jNG
Content-Type: text/plain;
  charset="UTF-8";
  name="siv_output_1.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="siv_output_1.txt"

[1 - 00 - 0] <- [PCI Bus] <- SIV64X - System Information Viewer V4.08 ASUS::Yannick

ATI Mobility Radeon HD 3400 Series - Vendor ID 1002-95C4-19D31043-00  size 0x1000  PCIe BAR 0x0000E0000000

Device Class             0x030000       VGA Controller
Command                  0x0507         I/O Access  Memory Access  Bus Master  System Errors
Status                   0x0010         Fast Timing  Has Capabilities List
Cache Line Size 8        2 ULONGs       Latency Timer 0 PCI clocks
Header Type 0x00         Prof IF 0x00   Built-in Self Test 0x00
Interrupt Line 0                        Interrupt Pin  0x01

BAR 0 (3.000GB)          0xC0000000     Alignment 0x40000000    1.000GB  ( Anywhere in 32-bit space, Prefetchable )
BAR 1 (I/O Port)         0x9000
BAR 2 (3.967GB)          0xFDDF0000     Alignment 0x00010000   64.000KB  ( Anywhere in 32-bit space )

Capabilities 0x50
  Power Management       Current D0     D0 - Device fully-operational, no power saving
                         Supports       D1 - Device operational, minimum power saving
                                        D2 - Device on standby, medium power saving

  PCI Express V2 Port 0  Device Type 1  Legacy PCI Express Endpoint  Interrupt Message Number 0
    DCAP  0x5C           0x012C8FA0     Max Payload 128 (Supported)  Power 75 W
    DCTL  0x60           0x0910         Max Payload 128  Max Read Request 128 (Current)
    LCTL  0x68           0x0000         Power Management Disabled
    LCAP  0x64           0x00000D01     Link Speed 2.5GT/s  Width x16  (Maximum)
    LSTS  0x6A           0x1101         Link Speed 2.5GT/s  Width x16  (Negotiated)
    SCAP  0x6C           0x00000000

  Message Interrupt      MSI Enabled    Message Address 0x00000000FEE0300C


--------------------------------------------


[Dump] <- [1 - 00 - 0] <- [PCI Bus] <- SIV64X - System Information Viewer V4.08 ASUS::Yannick

ATI Mobility Radeon HD 3400 Series - Vendor ID 1002-95C4-19D31043-00  size 0x1000  PCIe BAR 0x0000E0000000

            00        04        08        0C        10        14        18        1C        20        24        28        2C        30        34        38        3C
0000  95C41002  00100507  03000000  00000008  C0000008  00009001  FDDF0000  00000000  00000000  00000000  00000000  19D31043  00000000  00000050  00000000  00000100
0040  00000000  00000000  00000000  19D31043  06035801  00000000  0012A010  012C8FA0  00000910  00000D01  11010000  00000000  00000000  00000000  00000000  00000000
0080  00000000  00000000  00010001  00000000  00000000  00000000  00000000  00000000  00810005  FEE0300C  00000000  00004993  00000000  00000000  00000000  00000000
00C0  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
0100  0001000B  01010001  00000000  00000000  00010002  00000000  00000000  00000000  00000001  800000FF  00000000  00000001  00000000  00020000  00000000  00000000
0140  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
... repeated every 256 bytes
0F00  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
...
0FC0  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000

--------------------------------------------

[PCI BAR Addresses] <- SIV64X - System Information Viewer V4.08 ASUS::Yannick

SIV64X - Physical Memory and PCI BARs on \\ASUS - Windows 7 x64 Ultimate  V6.01  Build 7100

Physical Area  Base Address          about Limit Address         about Size                  about Flags

1              0x000000001000       4.00KB 0x00000009B000     620.00KB 0x00000009A000     616.00KB 0x00000103
2              0x000000100000       1.00MB 0x0000BFFA0000       3.00GB 0x0000BFEA0000       3.00GB 0x00000103
3              0x000100000000       4.00GB 0x000140000000       5.00GB 0x000040000000       1.00GB 0x00000103
                                                                       0x0000FFF3A000       4.00GB

BAR Area  Base Address        about Usage     PCI Location  Size               about 

          0x0000C0000000    3.000GB TOLUD     [0 - 00 - 0]

1         0x0000C0000000    3.000GB BAR 0     [1 - 00 - 0]  0x20000000     512.000MB
2         0x0000E0000000    3.500GB PCIEXBAR  [0 - 00 - 0]  0x1DDF0000     477.938MB
3         0x0000FDDF0000    3.967GB BAR 2     [1 - 00 - 0]  0x000D0000     832.000KB
4         0x0000FDEC0000    3.968GB BAR 0     [2 - 00 - 0]  0x0013E000       1.242MB
5         0x0000FDFFE000    3.969GB BAR 0     [3 - 00 - 0]  0x00100000       1.000MB
6         0x0000FE0FE000    3.970GB BAR 5     [4 - 00 - 0]  0x008E2000       8.883MB
7         0x0000FE9E0000    3.978GB ROM       [8 - 00 - 0]  0x0001FC00     127.000KB
8         0x0000FE9FFC00    3.979GB BAR 0     [8 - 00 - 0]  0x000FF000    1020.000KB
9         0x0000FEAFEC00    3.979GB BAR 0     [9 - 01 - 3]  0x00000400       1.000KB
10        0x0000FEAFF000    3.979GB BAR 0     [9 - 01 - 2]  0x00000400       1.000KB
11        0x0000FEAFF400    3.979GB BAR 0     [9 - 01 - 1]  0x00000400       1.000KB
12        0x0000FEAFF800    3.979GB BAR 0     [9 - 01 - 0]  0x000F8800     994.000KB
13        0x0000FEBF8000    3.980GB BAR 0     [0 - 27 - 0]  0x00007000      28.000KB
14        0x0000FEBFF000    3.980GB BAR 0     [0 - 29 - 7]  0x00000400       1.000KB
15        0x0000FEBFF400    3.980GB BAR 0     [0 - 26 - 7]  0x00000400       1.000KB
16        0x0000FEBFF800    3.980GB BAR 5     [0 - 31 - 2]  0x00114800       1.080MB
17        0x0000FED14000    3.982GB MCHBAR    [0 - 00 - 0]  0x00004000      16.000KB
18        0x0000FED18000    3.982GB DMIBAR    [0 - 00 - 0]  0x00001000       4.000KB
19        0x0000FED19000    3.982GB EPBAR     [0 - 00 - 0]  0x012E7000      18.902MB
                                    Total                   0x40000000       1.000GB


--Boundary-00=_6dfEMDCb2xH5jNG--
