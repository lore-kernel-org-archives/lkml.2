Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab2E0NlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 09:41:22 -0400
Received: from nm1.bullet.mail.bf1.yahoo.com ([98.139.212.160]:28986 "HELO
	nm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751603Ab2E0NlU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 09:41:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 853903.22365.bm@omp1036.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=oRmjjo/NgwLQiyncp2iaTsqnvgKAnthoD0aAiWcQnJ+OqIM60M3lXmyPGOu5EiJSZvHZfSl7gcuc2+3jCoDipSj88BVKzlKzC2PyHos0s4eoYmB3mhXl1aBlFkZ2I1CEvomcsXvBXtWqM+6VcNkJ2lm2wUone+bnCsHLmIY8KKg=;
X-YMail-OSG: _g6SEdAVM1lYEGB5rIaImRf1giheV0Eb9GW9mjQtLYMlVbA
 AIQM4B4Myvbi4f_2Jlv5gMGC.NzmL5pgDpKNr7HWwjpjhpc6ODCrK4MsQPcn
 0xI3avgQxNW3zxZK_NBuA18VUfn52Vp4FN0xJG9J0_xJQ_GYmD9eLKnADntF
 eYgnv1GHnA8t5CakfsGgFAAJlp4dK2yPU_8ljPcZbim.KBAxsOeDFRZg556x
 _DFy6Et.Od0cicXI6gZpIgJjQDZMoEKysQxOiKlsUtifxWpC4KIZPBc3u80Q
 JpoABJqYp1UZw428qHHM2doWYTsemBho5BsspUM4x8HtgXZPh3yLBFhJ0t.K
 k0eRjZiNMjbxUWHVpVk6XAPSxtXt0K35cLujYGdH5z4QIR9Sg_0U4SEMvkFe
 g48AWUEi8vaD6AGKji98_6SrS8TmBXJJug4AQ6J_sNEoOKql680u6VDuFGtx
 xuPuo.3xSHpIhEZu2soVoekEwjmPyqq_cy9mxb0oRzjluMah3xsg-
X-Mailer: YahooMailClassic/15.0.6 YahooMailWebService/0.8.118.349524
Message-ID: <1338126079.72906.YahooMailClassic@web162603.mail.bf1.yahoo.com>
Date: Sun, 27 May 2012 06:41:19 -0700 (PDT)
From: Denis Lotarev <dlotarev@yahoo.com>
Subject: Re: [BUG] Hibernate not working on laptop LENOVO X120e
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4FC21F57.8030507@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ 3815.547734] PM: Hibernation mode set to 'reboot'
[ 3855.971634] PM: Marking nosave pages: 000000000009d000 - 0000000000100000
[ 3855.971650] PM: Basic memory bitmaps created
[ 3855.971656] PM: Syncing filesystems ... done.
[ 3856.289592] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 3856.303363] PM: Preallocating image memory... done (allocated 192570 pages)
[ 3856.523221] PM: Allocated 770280 kbytes in 0.21 seconds (3668.00 MB/s)
[ 3856.523225] Freezing remaining freezable tasks ... (elapsed 0.06 seconds) done.
[ 3856.590732] Suspending console(s) (use no_console_suspend to debug)
[ 3856.593448] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 3856.700094] ACPI handle has no context!
[ 3857.161671] PM: freeze of devices complete after 570.918 msecs
[ 3857.162584] PM: late freeze of devices complete after 0.904 msecs
[ 3857.162589] Disabling non-boot CPUs ...
[ 3857.266621] CPU 1 is now offline
[ 3857.267709] PM: Creating hibernation image:
[ 3857.269841] PM: Need to copy 199391 pages
[ 3857.269841] PM: Normal pages needed: 33851 + 1024, available pages: 193315
[ 3857.269841] Enabling non-boot CPUs ...
[ 3857.275171] Booting Node 0 Processor 1 APIC 0x1
[ 3857.275176] smpboot cpu 1: start_ip = 99000
[ 3857.165224] Initializing CPU#1
[ 3857.165224] Calibrating delay loop (skipped) already calibrated this CPU
[ 3857.307016] NMI watchdog enabled, takes one hw-pmu counter.
[ 3857.307676] CPU1 is up
[ 3857.309381] PM: early restore of devices complete after 1.277 msecs
[ 3857.395335] snd_hda_intel 0000:00:01.1: irq 44 for MSI/MSI-X
[ 3857.443410] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[ 3857.443720] radeon 0000:00:01.0: WB enabled
[ 3857.443726] [drm] fence driver on ring 0 use gpu addr 0x18000c00 and cpu addr 0xff8d9c00
[ 3857.450369] usb usb4: root hub lost power or was reset
[ 3857.450410] usb usb3: root hub lost power or was reset
[ 3857.450439] usb usb2: root hub lost power or was reset
[ 3857.450470] usb usb1: root hub lost power or was reset
[ 3857.456563] r8169 0000:01:00.0: eth0: link down
[ 3857.463497] [drm] ring test on 0 succeeded in 1 usecs
[ 3857.463551] [drm] ib test on ring 0 succeeded in 0 usecs
[ 3857.883300] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 3857.886721] ata1.00: configured for UDMA/133
[ 3857.900110] sd 0:0:0:0: [sda] Starting disk
[ 3857.906712] usb 2-5: reset high-speed USB device number 4 using ehci_hcd
[ 3858.136665] usb 1-5: reset high-speed USB device number 3 using ehci_hcd
[ 3858.389846] usb 3-4: reset full-speed USB device number 2 using ohci_hcd
[ 3858.547049] btusb 3-4:1.0: no reset_resume for driver btusb?
[ 3858.547063] btusb 3-4:1.1: no reset_resume for driver btusb?
[ 3858.666618] usb 4-1: reset full-speed USB device number 2 using ohci_hcd
[ 3858.822757] btusb 4-1:1.0: no reset_resume for driver btusb?
[ 3858.822771] btusb 4-1:1.1: no reset_resume for driver btusb?
[ 3859.813977] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[ 3859.814093] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 3859.814107] ieee80211 phy0: changing basic rates failed: -22
[ 3859.814118] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[ 3859.814127] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[ 3859.814136] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 3859.814923] PM: restore of devices complete after 2422.415 msecs
[ 3859.817215] PM: Image restored successfully.
[ 3859.817226] Restarting tasks ... done.
[ 3859.829795] PM: Basic memory bitmaps freed
[ 3859.829809] video LNXVIDEO:01: Restoring backlight state

Your sincerely, Denis Lotarev


--- On Sun, 5/27/12, Arend van Spriel <arend@broadcom.com> wrote:

> From: Arend van Spriel <arend@broadcom.com>
> Subject: Re: [BUG] Hibernate not working on laptop LENOVO X120e
> To: "Denis Lotarev" <dlotarev@yahoo.com>
> Cc: linux-kernel@vger.kernel.org
> Date: Sunday, May 27, 2012, 4:34 PM
> On 05/27/2012 05:26 AM, Denis Lotarev
> wrote:
> > Hello!
> > My system on Lenovo X120e doesnt hibernate, when i
> trying to hibernate system power led begin often blinking
> (about 3 times at second), LCD turned off, HDD still
> working, and CPU fan workinkg too. There are no kernel log
> at messages, even if i run DEBUG=1 at pm-hibernate there are
> no errors at pm-hibernate.log. Suspent on RAM working good.
> > Linux lenarch 3.3.7-1-ARCH #1 SMP PREEMPT Mon May 21
> 22:39:59 UTC 2012 i686 GNU/Linux
> >  
> 
> Could you try:
> 
> # echo reboot > /sys/power/disk
> # echo disk > /sys/power/state
> 
> and provide the kernel log.
> 
> Gr. AvS
> 
> 
