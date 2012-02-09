Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab2BIEeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 23:34:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55229 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab2BIEeU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 23:34:20 -0500
MIME-Version: 1.0
In-Reply-To: <CALMYJDvy58ohVSjeQC2e=rccyKe2S=628q9YBFtpAm7v1HHO3Q@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
	<CAKYAXd_sRKCfw_rNrRD8yKKQEP_8Zee+E5rZW0G1NuuCA4HcNA@mail.gmail.com>
	<CAKYAXd_msUdB2UbMvxqn751nuN5R=T6W5sjLDMxqEOR6KTX38w@mail.gmail.com>
	<CALMYJDvy58ohVSjeQC2e=rccyKe2S=628q9YBFtpAm7v1HHO3Q@mail.gmail.com>
Date: Thu, 9 Feb 2012 13:34:18 +0900
Message-ID: <CAKYAXd83xkxyPNYJf-fBf+oZ8h3GTuRd_8POe6m61t6_AW-mQg@mail.gmail.com>
Subject: Re: [PATCH 0/4] [SCSI] ufshcd: UFS Host Controller Driver
From: Namjae Jeon <linkinjeon@gmail.com>
To: Santosh Y <santoshsy@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>,
        James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org,
        arnd@arndb.de, venkat@linaro.org, girish.shivananjappa@linaro.org,
        vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/6 Santosh Y <santoshsy@gmail.com>:
> On Mon, Feb 6, 2012 at 4:15 AM, Namjae Jeon <linkinjeon@gmail.com> wrote:
>> 2012/2/5 Namjae Jeon <linkinjeon@gmail.com>:
>>> 2012/2/2 Vinayak Holikatti <vinholikatti@gmail.com>:
>>>> From: Santosh Yaraganavi <santoshsy@gmail.com>
>>>>
>>>> UFS is designed to be the most advanced specification for
>>>> both embedded and removable flash memory-based storage in mobile devices
>>>> such as smart phones and tablet computers.  The UFS standard represents
>>>> an evolutionary progression of JEDEC standards in this field, and has been
>>>> specifically tailored for mobile applications and computing systems requiring
>>>> high performance and low power consumption.  The initial data throughput for
>>>> UFS will be ~300 megabytes per second (MB/s), and the standard also supports
>>>> command queuing features to raise random read/write speeds.
>>>>
>>>> To achieve the highest performance and most power efficient data
>>>> transport, UFS uses the leading industry interface standards to form its
>>>> Interconnect Layer: MIPI® Alliance’s M-PHY and UniProSM  specifications.
>>>> UniPro is a comprehensive specification meant to act as a universal
>>>> chip-to-chip protocol, providing a common tunnel for other protocols.
>>>> The M-PHY interface is designed as the primary physical interface (PHY layer)
>>>> for the UniPro specification, and is a high speed serial interface targeting
>>>> up to 2.9 gigabits per second (Gbps) per lane with up-scalability to 5.8Gbps
>>>> per lane.
>>>>
>>>> MIPI’s M-PHY and UniPro specifications are optimized for mobile applications,
>>>> and are designed from the ground up for efficient power management in mobile
>>>> devices, including enabling efficient transitions between the active and power
>>>> save modes. Combined with a low active power level and a near-zero idle power
>>>> level, UFS offers the promise for significant reductions in device power
>>>> consumption.
>>>>
>>>> The UFS standard adopts the well-known SCSI Architecture Model and command
>>>> protocols supporting multiple commands with command queuing features and
>>>> enabling a multi-thread programming paradigm. This differs from conventional
>>>> flash-based memory cards and embedded flash solutions which process one
>>>> command at a time, limiting random read/write access performance.
>>>> In addition, a forthcoming complementary UFS Host Controller Interface (HCI)
>>>> specification will allow system designers greater flexibility by simplifying
>>>> the involvement of the host processor in the operation of the flash storage
>>>> subsystem. The UFS HCI specification and the adoption of SCSI will provide
>>>> a well-known software programming model and enable wider market adoption.
>>>>
>>>> This patchset contains PCIe based UFS host controller driver which complies
>>>> to UFSHCI 1.0 and 1.1. The driver is based on Linux SCSI framework.
>>>> The driver is tested with UFS Host controller(FPGA) and UFS device(FPGA).
>>>>
>>>> This patch set is successfully applied on kernel version 3.3-rc2.
>>>>
>>>> Santosh Yaraganavi (4):
>>>>  [SCSI] ufshcd: UFS Host controller driver
>>>>  [SCSI] ufshcd: UFS UTP Transfer requests handling
>>>>  [SCSI] ufshcd: UFSHCI error handling
>>>>  [SCSI] ufshcd: SCSI error handling
>>>>
>>>>  drivers/scsi/Kconfig      |    1 +
>>>>  drivers/scsi/Makefile     |    1 +
>>>>  drivers/scsi/ufs/Kconfig  |   49 ++
>>>>  drivers/scsi/ufs/Makefile |    2 +
>>>>  drivers/scsi/ufs/ufs.h    |  203 +++++
>>>>  drivers/scsi/ufs/ufshcd.c | 1954 +++++++++++++++++++++++++++++++++++++++++++++
>>>>  drivers/scsi/ufs/ufshci.h |  360 +++++++++
>>>>  7 files changed, 2570 insertions(+), 0 deletions(-)
>>>>  create mode 100644 drivers/scsi/ufs/Kconfig
>>>>  create mode 100644 drivers/scsi/ufs/Makefile
>>>>  create mode 100644 drivers/scsi/ufs/ufs.h
>>>>  create mode 100644 drivers/scsi/ufs/ufshcd.c
>>>>  create mode 100644 drivers/scsi/ufs/ufshci.h
>>>>
>>>> --
>>>> 1.7.5.4
>>> Hi.
>>> I have been waiting for ufs contribution.
>>> Unfortunately I don't have real target supported ufs(maybe only you
>>> have it). I can not debug and run this code, So just review only code
>>> with specification.
>>>>
>> Hi. Santosh.
>> Would you share performance measurement result (read/write seq,ran) ?
>> Thanks.
>
> Hi Namjae,
>
> Currently UFS Driver is being tested on on UFS Controller FPGA and UFS
> Device FPGA. So currently the main concentration is on functionality.
> Performance on FPGA will not be the correct measurement.
Hi. Santosh.
If possible, I hope that you share performance to us when you post new
patch next time.
And Personally I am expecting good random I/O speed on UFS.
Thanks.
>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> ~Santosh
