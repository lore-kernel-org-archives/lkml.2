Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1BBHzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:55:42 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39190 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1BBHzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:55:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=D/1SFdBRnTn8uO82055Oq1H8kAxYcIyFUXM+4eQfyyYLdhf/ixm82eRbrPAFTMe0eR
         6Lt6YQFdgpbjr30iGKzwGSvNdNIVJhIXCYqJWduyjOzaKmWKvq3xkZdRyBqNnDWVVrWi
         ZJi0M9wYya/AuILC9ilmrpe8Ip0yAaIK4OA0c=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110104210307.GB6130@amt.cnet>
References: <1294009289-28802-1-git-send-email-sedat.dilek@gmail.com>
	<20110104210307.GB6130@amt.cnet>
Date: Wed, 2 Feb 2011 08:55:39 +0100
Message-ID: <AANLkTi=V6PvG42bBmE=7qcm=5vvk=SeUJ6a8oMKOcihb@mail.gmail.com>
Subject: Re: [PATCH] kvm: Fix section mismatch derived from kvm_guest_cpu_online()
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        riel@redhat.com, gleb@redhat.com, avi@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 10:03 PM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Mon, Jan 03, 2011 at 12:01:29AM +0100, Sedat Dilek wrote:
>> >From my build.log:
>>
>> WARNING: arch/x86/built-in.o(.text+0x1bb74): Section mismatch in reference from the function kvm_guest_cpu_online() to the function .cpuinit.text:kvm_guest_cpu_init()
>> The function kvm_guest_cpu_online() references
>> the function __cpuinit kvm_guest_cpu_init().
>> This is often because kvm_guest_cpu_online lacks a __cpuinit
>> annotation or the annotation of kvm_guest_cpu_init is wrong.
>>
>> This patch fixes the warning.
>>
>> Tested with linux-next (next-20101231)
>>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> Applied, thanks.
>
>

PING!

Was this patch really applied? I have it still in my patch-series.

- Sedat -

P.S.: My current patch-series

sd@tbox:~/src/linux-2.6$ grep OK setup_linux-next_next20110202.dileks.1.log
  (+) OK   linux-next/patch-v2.6.38-rc3-next-20110202
  (+) OK   linux-next/Remove-localversion-next.patch
  (+) OK   debian/version.patch
  (+) OK   debian/kernelvariables-v2.patch
  (+) OK   debian/doc-build-parallel.patch
  (+) OK   bugfix/ia64/hardcode-arch-script-output.patch
  (+) OK   bugfix/mips/disable-advansys.patch
  (+) OK   bugfix/arm/disable-scsi_acard.patch
  (+) OK   debian/mips-disable-werror.patch
  (+) OK   bugfix/powerpc/lpar-console.patch
  (+) OK   features/all/i915-autoload-without-CONFIG_DRM_I915_KMS.patch
  (+) OK   debian/arch-sh4-fix-uimage-build.patch
  (+) OK   debian/af_802154-Disable-auto-loading-as-mitigation-against.patch
  (+) OK   debian/rds-Disable-auto-loading-as-mitigation-against-local.patch
  (+) OK   debian/decnet-Disable-auto-loading-as-mitigation-against-lo.patch
  (+) OK   bugfix/mips/mips-ide-flush-dcache.patch
  (+) OK   bugfix/all/qla4xxx-Fix-build-on-some-architectures-lacking-64-bit-I-O.patch
  (+) OK   bugfix/x86/Skip-looking-for-ioapic-overrides-when-ioapics-are-not-present.patch
  (+) OK   bugfix/arm/ixp4xx-add-missing-export.patch
  (+) OK   features/all/Kbuild-kconfig-Verbose-version-of-listnewconfig-v2.patch
  (+) OK   bugfix/arm/arm-ixp4xx-Rename-FREQ-macro-to-avoid-collisions-2.patch
  (+) OK   debian/alpha-Do-not-use-Werror-for-arch-alpha-v2.patch
  (+) OK   from-johill/001-debug-section-mismatch.patch
  (+) OK   linux-2.6-trace-unlikely/linux-2.6-trace-unlikely.patch
  (+) OK   mm-fix/cgroup-Avoid-a-memset-by-using-vzalloc.patch
  (+) OK   danvet-drm-for-sedat-dilek-v2/0001-drm-nouveau-don-t-munge-in-drm_mm-internals.patch
  (+) OK   danvet-drm-for-sedat-dilek-v2/0002-drm-mm-track-free-areas-implicitly.patch
  (+) OK   danvet-drm-for-sedat-dilek-v2/0003-drm-mm-extract-node-insert-helper-functions.patch
  (+) OK   danvet-drm-for-sedat-dilek-v2/0004-drm-mm-add-api-for-embedding-struct-drm_mm_node.patch
  (+) OK   danvet-drm-for-sedat-dilek-v2/0005-drm-mm-add-helper-to-unwind-scan-state.patch
  (+) OK   danvet-drm-for-sedat-dilek-v2/0006-drm-nouveau-don-t-munge-in-drm_mm-internals-follow-u.patch
  (+) OK   danvet-drm-for-sedat-dilek-v2-fix/0001-drm-nouveau-don-t-munge-in-drm_mm-internals-follow-u.patch
  (+) OK   danvet-embed-drm_gem_object-into-radeon_bo/1-3-drm-radeon-embed-struct-drm_gem_object-v2.patch
  (+) OK   danvet-embed-drm_gem_object-into-radeon_bo/2-3-drm-radeon-introduce-gem_to_radeon_bo-helper.patch
  (+) OK   danvet-embed-drm_gem_object-into-radeon_bo/3-3-drm-radeon-kill-radeon_bo--gobj-pointer.patch
  (+) OK   drm-radeon-kms-writeback/drm-radeon-kms-Enable-writeback-on-radeon-AGP-boards.patch
  (+) OK   backlight-type/1-5-Backlight-Add-backlight-type.patch
  (+) OK   backlight-type/2-5-i915-Add-native-backlight-control.patch
  (+) OK   backlight-type/v2-drm-radeon-kms-Expose-backlight-class-device-for-legacy-LVDS-encoder.patch
  (+) OK   backlight-type/4-5-nouveau-Change-the-backlight-parent-device-to-the-connector-not-the-PCI-dev.patch
  (+) OK   backlight-type/5-5-ACPI-Tie-ACPI-backlight-devices-to-PCI-devices-if-possible.patch
  (+) OK   drm-driverdate-coredate-removal/0001-drm-Remove-DRIVER_DATE-from-drm-drivers.patch
  (+) OK   drm-driverdate-coredate-removal/0002-drm-Remove-CORE_DATE-from-drm-core-and-drm-sysfs.patch
  (+) OK   drm-driverdate-coredate-removal/0003-drm-Fix-DRM_INFO-after-DRIVER_DATE-CORE_DATE-removal.patch
  (+) OK   drm-driverdate-coredate-removal/0004-drm-Remove-date_len-and-date-from-drm_version.patch
  (+) OK   mac80211-fix/mac80211-minstrel-honor-max-retry-counts-from-cfg80211.patch
  (+) OK   kvm-fix/kvm-Fix-section-mismatch-derived-from-kvm_guest_cpu_online.patch

- EOT -
