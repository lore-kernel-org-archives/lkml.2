Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0FCXCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:02:24 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:38345 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab0FCXCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:02:22 -0400
From: Yannick Roehlly <yannick.roehlly@free.fr>
To: Yinghai Lu <yinghai.lu@oracle.com>
Subject: Re: [PATCH -v2] pci: clear bridge resource size if BIOS assign bad one
Date: Fri, 4 Jun 2010 01:02:11 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-bfs; KDE/4.4.4; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <bug-16009-13546@https.bugzilla.kernel.org/> <4C070ECA.2020309@oracle.com> <4C0813D7.7080900@oracle.com> (sfid-20100603_235010_934155_EA9AC6E8)
In-Reply-To: <4C0813D7.7080900@oracle.com>
Face: =?utf-8?q?iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAGFBMVEXCuqeIxKzp?=
 =?utf-8?q?5sRygG8s=0A?=
 =?utf-8?q?_JiCIaEGZn2iYtHQ2rVJpAAACWElEQVQ4jW3TzW7iMBAAYMtLcl5v2LtrEs6bO?=
 =?utf-8?q?rRXwBN6ZSHj=0A?=
 =?utf-8?q?_XiOKzQtU9PV3xoY2ldZSQPKXmcn4Rygav+NkYHw1NATD02TexxgSmAdVIU8EH9Ej?=
 =?utf-8?q?EuwzGFX5=0A?=
 =?utf-8?q?_GJBG+iFBmeGhijgZ9NYNzMIHTpKnC/S3GsZomjWC0/lRGsTYqgxNwIMRQpRCC2E?=
 =?utf-8?q?Khl93MDSV=0A?=
 =?utf-8?q?_h9EY/yqVIIT9F1Aub6k3hmU4TCH4NoFSNqQS91xFBnqqcJpCM4GDGO+59LeIOMA?=
 =?utf-8?q?+iSnxNAGU=0A?=
 =?utf-8?q?_AWFHQi9Av8Q7KDxoWpWdXgKtx/gJlcNTA72PohlxgINGaBN0RS/rzvWjaErYuO?=
 =?utf-8?q?1y2LsE4GkD=0A?=
 =?utf-8?q?_Zu5xFMVYu61ZInYZZsGUNUgtitMCHkfzsoYEToIxfyx9bBGF/WFMr4cE64YgNVeUIy8?=
 =?utf-8?q?v7N8d=0A?=
 =?utf-8?q?_g20Gqb9ALlbbAVqC+er4mEDXJS9vXRwBNsLaqltvUypdeg6rZ8BAjwtrAomi7Hl?=
 =?utf-8?q?vzzh0Cdx8=0A?=
 =?utf-8?q?_CxxR9MPI6wgcoQig7TquLoXUWsgH5yrYJIC22qbqS9xT7VZVts3w8kxF6PgVTRR?=
 =?utf-8?q?yZq1Fa0Xl=0A?=
 =?utf-8?q?_AHbxbETBr6yF6fORFE9+AH85n+TIJ1aLpcOjxbASV//mr9fIRVLf9fGYzr3Id+U?=
 =?utf-8?q?y3M7JPdNK=0A?=
 =?utf-8?q?_XPJFCuv0XXL2/Harkaep2RPDgj6gx+PKZjhzL8C3InW9+4ygDVObKrVKm6rg6u?=
 =?utf-8?q?MHQ9gwqPn2=0A?=
 =?utf-8?q?_TNvZVmr+SpMM55aadaqjhVbO2rZ6uYMi6H5wKgarvkPXIViwCa5TcJTKdgl2HH?=
 =?utf-8?q?G9AeUGl/4J=0A?=
 =?utf-8?q?_UsTl4z2DBUc78QUxZmhVf/wv2J/YT1L9A+9D53ETf4qfAAAAAElFTkSuQmCC?=
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006040102.11580.yannick.roehlly@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Thursday 03 June 2010 22:43:03 Yinghai Lu, vous avez écrit :
> Make sure We can reject wrong size from BIOS.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=16009
> Yannick found that video does not work with 2.6.34

Hi Yinghai,

I tested the 2nd version of your patch. I still works.

Cheers,

Yannick
