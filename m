Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab0LHJvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 04:51:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47388 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab0LHJv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 04:51:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=vR6epK7TzDHRKHLa9F67aE+N66SeXRJb6kASBSMLeCyTJcoSJCzS4nP0kYy1iXQque
         pusiVzwFXR4G+CPIX8vyOzGP9+kXEetNa0fZbjL45azApsZGwKu2839qbZ4eV25AqUmQ
         Ccl8T3INt2ImNDz/61oz5ebprl9b03DesUAZ0=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTim5picexJzLpJN6BGUeo28Cf1h_VQe+X=UY+mL8@mail.gmail.com>
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
	<AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
	<AANLkTim5picexJzLpJN6BGUeo28Cf1h_VQe+X=UY+mL8@mail.gmail.com>
Date: Wed, 8 Dec 2010 10:51:26 +0100
Message-ID: <AANLkTinScHqtarh-qgxQn2hxm1iBuDdJML9Kz5FwV8zv@mail.gmail.com>
Subject: Re: linux-next: Tree for December 8 (drivers/platform/x86/Kconfig:422:error:
 recursive dependency detected!)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: multipart/mixed; boundary=0016363b85209045fa0496e310e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016363b85209045fa0496e310e6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 8, 2010 at 10:28 AM, Sedat Dilek <sedat.dilek@googlemail.com> w=
rote:
> On Wed, Dec 8, 2010 at 10:12 AM, Corentin Chary
> <corentin.chary@gmail.com> wrote:
>> On Wed, Dec 8, 2010 at 9:17 AM, Sedat Dilek <sedat.dilek@googlemail.com>=
 wrote:
>>> Hi,
>>>
>>> just wanted to build a new linux-next and see this:
>>>
>>> [ setup.log ]
>>> ...
>>> dileks.1" make -C 'debian/build/source_i386_none'
>>> O=3D'/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_no=
ne_686'
>>> oldnoconfig
>>> make[2]: Entering directory
>>> `/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
>>> =C2=A0HOSTCC =C2=A0scripts/basic/fixdep
>>> =C2=A0HOSTCC =C2=A0scripts/basic/docproc
>>> =C2=A0GEN =C2=A0 =C2=A0 /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/=
build/build_i386_none_686/Makefile
>>> =C2=A0HOSTCC =C2=A0scripts/kconfig/conf.o
>>> =C2=A0HOSTCC =C2=A0scripts/kconfig/kxgettext.o
>>> =C2=A0SHIPPED scripts/kconfig/zconf.tab.c
>>> =C2=A0SHIPPED scripts/kconfig/lex.zconf.c
>>> =C2=A0SHIPPED scripts/kconfig/zconf.hash.c
>>> =C2=A0HOSTCC =C2=A0scripts/kconfig/zconf.tab.o
>>> =C2=A0HOSTLD =C2=A0scripts/kconfig/conf
>>> scripts/kconfig/conf --oldnoconfig Kconfig
>>> drivers/platform/x86/Kconfig:422:error: recursive dependency detected!
>>> drivers/platform/x86/Kconfig:422: =C2=A0 =C2=A0 =C2=A0 symbol EEEPC_WMI=
 depends on ACPI_WMI
>>> drivers/platform/x86/Kconfig:438: =C2=A0 =C2=A0 =C2=A0 symbol ACPI_WMI =
is selected by ACER_WMI
>>> drivers/platform/x86/Kconfig:18: =C2=A0 =C2=A0 =C2=A0 =C2=A0symbol ACER=
_WMI depends on LEDS_CLASS
>>> drivers/leds/Kconfig:10: =C2=A0 =C2=A0 =C2=A0 =C2=A0symbol LEDS_CLASS i=
s selected by EEEPC_WMI
>>> warning: (ADB_PMU_LED && MACINTOSH_DRIVERS && ADB_PMU || ATH5K &&
>>> NETDEVICES && WLAN && ATH_COMMON && (PCI || ATHEROS_AR231X) &&
>>> MAC80211 || ATH9K && NETDEVICES && WLAN && ATH_COMMON && PCI &&
>>> MAC80211 || ATH9K_HTC && NETDEVICES && WLAN && ATH_COMMON && USB &&
>>> MAC80211 || CARL9170_LEDS && NETDEVICES && WLAN && ATH_COMMON &&
>>> CARL9170 || INPUT_WISTRON_BTNS && !S390 && INPUT && INPUT_MISC && X86
>>> && !X86_64 || SENSORS_APPLESMC && HWMON && INPUT && X86 ||
>>> SENSORS_LIS3LV02D && HWMON && ACPI && INPUT || IR_WINBOND_CIR &&
>>> MEDIA_SUPPORT && X86 && PNP && RC_CORE || BACKLIGHT_ADP8860 &&
>>> HAS_IOMEM && BACKLIGHT_LCD_SUPPORT && BACKLIGHT_CLASS_DEVICE && I2C ||
>>> MSM_STAGING && STAGING && !STAGING_EXCLUDE_BUILD && FB && ARCH_MSM &&
>>> !FB_MSM || ASUS_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI &&
>>> !ACPI_ASUS && INPUT && (RFKILL || RFKILL=3Dn) || THINKPAD_ACPI && X86 &=
&
>>> X86_PLATFORM_DEVICES && ACPI && INPUT && (RFKILL || RFKILL=3Dn) ||
>>> EEEPC_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI && INPUT &&
>>> EXPERIMENTAL && (RFKILL || RFKILL=3Dn) && HOTPLUG_PCI || EEEPC_WMI &&
>>> X86 && X86_PLATFORM_DEVICES && ACPI_WMI && INPUT && EXPERIMENTAL &&
>>> BACKLIGHT_CLASS_DEVICE && (RFKILL || RFKILL=3Dn)) selects LEDS_CLASS
>>> which has unmet direct dependencies (NEW_LEDS)
>>> #
>>> # configuration written to .config
>>> #
>>> make[2]: Leaving directory
>>> `/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
>>> env -u ABINAME -u ARCH -u FEATURESET -u FLAVOUR -u VERSION -u
>>> LOCALVERSION DISTRIBUTION_OFFICIAL_BUILD=3D1
>>> DISTRIBUTION_UPLOADER=3Dsedat.dilek@gmail.com
>>> DISTRIBUTION_VERSION=3D"2.6.37~rc5-1~next20101208.dileks.1" make -C
>>> 'debian/build/source_i386_none'
>>> O=3D'/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/build_i386_no=
ne_686'
>>> =C2=A0prepare
>>> make[2]: Entering directory
>>> `/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
>>> =C2=A0GEN =C2=A0 =C2=A0 /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/=
build/build_i386_none_686/Makefile
>>> scripts/kconfig/conf --silentoldconfig Kconfig
>>> drivers/platform/x86/Kconfig:422:error: recursive dependency detected!
>>> drivers/platform/x86/Kconfig:422: =C2=A0 =C2=A0 =C2=A0 symbol EEEPC_WMI=
 depends on ACPI_WMI
>>> drivers/platform/x86/Kconfig:438: =C2=A0 =C2=A0 =C2=A0 symbol ACPI_WMI =
is selected by ACER_WMI
>>> drivers/platform/x86/Kconfig:18: =C2=A0 =C2=A0 =C2=A0 =C2=A0symbol ACER=
_WMI depends on LEDS_CLASS
>>> drivers/leds/Kconfig:10: =C2=A0 =C2=A0 =C2=A0 =C2=A0symbol LEDS_CLASS i=
s selected by EEEPC_WMI
>>> warning: (ADB_PMU_LED && MACINTOSH_DRIVERS && ADB_PMU || ATH5K &&
>>> NETDEVICES && WLAN && ATH_COMMON && (PCI || ATHEROS_AR231X) &&
>>> MAC80211 || ATH9K && NETDEVICES && WLAN && ATH_COMMON && PCI &&
>>> MAC80211 || ATH9K_HTC && NETDEVICES && WLAN && ATH_COMMON && USB &&
>>> MAC80211 || CARL9170_LEDS && NETDEVICES && WLAN && ATH_COMMON &&
>>> CARL9170 || INPUT_WISTRON_BTNS && !S390 && INPUT && INPUT_MISC && X86
>>> && !X86_64 || SENSORS_APPLESMC && HWMON && INPUT && X86 ||
>>> SENSORS_LIS3LV02D && HWMON && ACPI && INPUT || IR_WINBOND_CIR &&
>>> MEDIA_SUPPORT && X86 && PNP && RC_CORE || BACKLIGHT_ADP8860 &&
>>> HAS_IOMEM && BACKLIGHT_LCD_SUPPORT && BACKLIGHT_CLASS_DEVICE && I2C ||
>>> MSM_STAGING && STAGING && !STAGING_EXCLUDE_BUILD && FB && ARCH_MSM &&
>>> !FB_MSM || ASUS_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI &&
>>> !ACPI_ASUS && INPUT && (RFKILL || RFKILL=3Dn) || THINKPAD_ACPI && X86 &=
&
>>> X86_PLATFORM_DEVICES && ACPI && INPUT && (RFKILL || RFKILL=3Dn) ||
>>> EEEPC_LAPTOP && X86 && X86_PLATFORM_DEVICES && ACPI && INPUT &&
>>> EXPERIMENTAL && (RFKILL || RFKILL=3Dn) && HOTPLUG_PCI || EEEPC_WMI &&
>>> X86 && X86_PLATFORM_DEVICES && ACPI_WMI && INPUT && EXPERIMENTAL &&
>>> BACKLIGHT_CLASS_DEVICE && (RFKILL || RFKILL=3Dn)) selects LEDS_CLASS
>>> which has unmet direct dependencies (NEW_LEDS)
>>> =C2=A0Using /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source=
_i386_none
>>> as source for kernel
>>> =C2=A0GEN =C2=A0 =C2=A0 /home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/=
build/build_i386_none_686/Makefile
>>> =C2=A0CHK =C2=A0 =C2=A0 include/linux/version.h
>>> =C2=A0UPD =C2=A0 =C2=A0 include/linux/version.h
>>> =C2=A0CHK =C2=A0 =C2=A0 include/generated/utsrelease.h
>>> =C2=A0UPD =C2=A0 =C2=A0 include/generated/utsrelease.h
>>> =C2=A0CC =C2=A0 =C2=A0 =C2=A0kernel/bounds.s
>>> =C2=A0GEN =C2=A0 =C2=A0 include/generated/bounds.h
>>> =C2=A0CC =C2=A0 =C2=A0 =C2=A0arch/x86/kernel/asm-offsets.s
>>> =C2=A0GEN =C2=A0 =C2=A0 include/generated/asm-offsets.h
>>> =C2=A0CALL =C2=A0 =C2=A0/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/=
build/source_i386_none/scripts/checksyscalls.sh
>>> make[2]: Leaving directory
>>> `/home/sd/src/linux-2.6/linux-2.6.37-rc5/debian/build/source_i386_none'
>>> make[1]: Leaving directory `/home/sd/src/linux-2.6/linux-2.6.37-rc5'
>>>
>>> Regards,
>>> - Sedat -
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe platform-driv=
er-x86" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>>>
>>
>> Hum ...
>> ACER_WMI:
>> =C2=A0select ACPI_WMI
>> =C2=A0depends on LEDS_CLASS
>> =C2=A0depends on NEW_LEDS
>>
>> EEEPC_WMI:
>> =C2=A0depends on ACPI_WMI
>> =C2=A0select LEDS_CLASS
>> =C2=A0select NEW_LEDS
>>
>> I don't really see how it's a recursive dependency, but maybe it's
>> time to clean this KConfig.
>> What is our current policy about that ?
>>
>> I think we should *depends* on important subsystem (ACPI, INPUT, ...)
>> and select obscure things so
>> that the driver does not get lost if you don't enable the leds.
>>
>> depends:
>> - ACPI
>> - INPUT
>> - EXPERIMENTAL
>> - RFKILL
>> - ACPI_WMI ?
>> - HWMON ?
>> - THERMAL ?
>>
>> select:
>> - BACKLIGHT_CLASS_*
>> - LEDS_CLASS
>> - NEW_LEDS
>> - INPUT_*
>>
>> --
>> Corentin Chary
>> http://xf.iksaif.net
>>
>
> The last 3 commits touching drivers/platform/x86/Kconfig:
>
> $ git log -3 drivers/platform/x86/Kconfig
>
> commit 8c75facc93240c864bcbc9b45c492b32725ad2d4
> Author: Corentin Chary <corentincj@iksaif.net>
> Date: =C2=A0 Mon Nov 29 08:14:07 2010 +0100
>
> =C2=A0 =C2=A0eeepc-wmi: add rfkill support for wlan, bluetooth and 3g
>
> =C2=A0 =C2=A0wimax support is missing because I don't have any DSDT
> =C2=A0 =C2=A0with WMI and wimax support.
>
> =C2=A0 =C2=A0Most of the code comes from eeepc-laptop.
>
> =C2=A0 =C2=A0Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> =C2=A0 =C2=A0Signed-off-by: Matthew Garrett <mjg@redhat.com>
>
> commit 41eeea57adfb7d37b4a826877a8a6965cae5fb4a
> Author: Corentin Chary <corentincj@iksaif.net>
> Date: =C2=A0 Mon Nov 29 08:14:06 2010 +0100
>
> =C2=A0 =C2=A0eeepc-wmi: add touchpad led support
>
> =C2=A0 =C2=A0Most of the code comes from eeepc-laptop.
>
> =C2=A0 =C2=A0Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> =C2=A0 =C2=A0Signed-off-by: Matthew Garrett <mjg@redhat.com>
>
> commit 02846193f7b31e7f12a007894bdb1b4f4d7d6c22
> Author: Sreedhara DS <sreedhara.ds@intel.com>
> Date: =C2=A0 Fri Oct 22 15:43:55 2010 +0100
>
> =C2=A0 =C2=A0intel_scu_ipc: Utility driver for intel scu ipc
> ...
>

The following patch fixes the issue here (setup.log attached).

- Sedat -

--0016363b85209045fa0496e310e6
Content-Type: plain/text; 
	name="platform-x86-Kconfig-Replace-select-by-depends-on-ACPI_WMI.patch"
Content-Disposition: attachment; 
	filename="platform-x86-Kconfig-Replace-select-by-depends-on-ACPI_WMI.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghg1gjd70

LS0tIHNvdXJjZV9pMzg2X25vbmUub3JpZy9kcml2ZXJzL3BsYXRmb3JtL3g4Ni9LY29uZmlnCTIw
MTAtMTItMDggMTA6NDA6MzEuNjE2MDI0MjQwICswMTAwCisrKyBzb3VyY2VfaTM4Nl9ub25lL2Ry
aXZlcnMvcGxhdGZvcm0veDg2L0tjb25maWcJMjAxMC0xMi0wOCAxMDo0MzoyOC45MjU3OTUxNTYg
KzAxMDAKQEAgLTIzLDcgKzIzLDcgQEAgY29uZmlnIEFDRVJfV01JCiAJZGVwZW5kcyBvbiBCQUNL
TElHSFRfQ0xBU1NfREVWSUNFCiAJZGVwZW5kcyBvbiBTRVJJT19JODA0MgogCWRlcGVuZHMgb24g
UkZLSUxMIHx8IFJGS0lMTCA9IG4KLQlzZWxlY3QgQUNQSV9XTUkKKwlkZXBlbmRzIG9uIEFDUElf
V01JCiAJLS0taGVscC0tLQogCSAgVGhpcyBpcyBhIGRyaXZlciBmb3IgbmV3ZXIgQWNlciAoYW5k
IFdpc3Ryb24pIGxhcHRvcHMuIEl0IGFkZHMKIAkgIHdpcmVsZXNzIHJhZGlvIGFuZCBibHVldG9v
dGggY29udHJvbCwgYW5kIG9uIHNvbWUgbGFwdG9wcywKQEAgLTEzMSw3ICsxMzEsNyBAQCBjb25m
aWcgVEMxMTAwX1dNSQogCWRlcGVuZHMgb24gIVg4Nl82NAogCWRlcGVuZHMgb24gRVhQRVJJTUVO
VEFMCiAJZGVwZW5kcyBvbiBBQ1BJCi0Jc2VsZWN0IEFDUElfV01JCisJZGVwZW5kcyBvbiBBQ1BJ
X1dNSQogCS0tLWhlbHAtLS0KIAkgIFRoaXMgaXMgYSBkcml2ZXIgZm9yIHRoZSBXTUkgZXh0ZW5z
aW9ucyAod2lyZWxlc3MgYW5kIGJsdWV0b290aCBwb3dlcgogCSAgY29udHJvbCkgb2YgdGhlIEhQ
IENvbXBhcSBUQzExMDAgdGFibGV0Lgo=
--0016363b85209045fa0496e310e6
Content-Type: application/octet-stream; name="setup.log"
Content-Disposition: attachment; filename="setup.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghg1hejv1

bWFrZSAtZiBkZWJpYW4vcnVsZXMucmVhbCBzZXR1cC1mbGF2b3VyIEFCSU5BTUU9JycgQVJDSD0n
aTM4NicgQ09NUElMRVI9J2djYy00LjQnIEZFQVRVUkVTRVQ9J25vbmUnIEZMQVZPVVI9JzY4Nicg
SU5JVFJEX0NNRD0ndXBkYXRlLWluaXRyYW1mcycgS0NPTkZJRz0nZGViaWFuL2NvbmZpZy9jb25m
aWcgZGViaWFuL2NvbmZpZy9rZXJuZWxhcmNoLXg4Ni9jb25maWcgZGViaWFuL2NvbmZpZy9rZXJu
ZWxhcmNoLXg4Ni9jb25maWctYXJjaC0zMiBkZWJpYW4vY29uZmlnL2kzODYvbm9uZS9jb25maWcu
Njg2JyBLRVJORUxfQVJDSD0neDg2JyBMT0NBTFZFUlNJT049Jy02ODYnIExPQ0FMVkVSU0lPTl9I
RUFERVJTPScnIExPQ0FMVkVSU0lPTl9JTUFHRT0nLTY4NicgTUFKT1I9JzIuNicgTU9EVUxFUz0n
VHJ1ZScgU09VUkNFVkVSU0lPTj0nMi42LjM3fnJjNS0xfm5leHQyMDEwMTIwOC5kaWxla3MuMScg
VFlQRT0ncGxhaW4nIFVQU1RSRUFNVkVSU0lPTj0nMi42LjM3LXJjNScgVkVSU0lPTj0nMi42LjM3
JwptYWtlWzFdOiBFbnRlcmluZyBkaXJlY3RvcnkgYC9ob21lL3NkL3NyYy9saW51eC0yLjYvbGlu
dXgtMi42LjM3LXJjNScKcm0gLXJmICdkZWJpYW4vYnVpbGQvc291cmNlJwpta2RpciAtcCAnZGVi
aWFuL2J1aWxkL3NvdXJjZScKY3AgLWFsIGFyY2ggYmxvY2sgQ09QWUlORyBDUkVESVRTIGNyeXB0
byBEb2N1bWVudGF0aW9uIGRyaXZlcnMgZmlybXdhcmUgZnMgaW5jbHVkZSBpbml0IGlwYyBLYnVp
bGQgS2NvbmZpZyBrZXJuZWwgbGliIE1BSU5UQUlORVJTIE1ha2VmaWxlIG1tIG5ldCBSRUFETUUg
UkVQT1JUSU5HLUJVR1Mgc2FtcGxlcyBzY3JpcHRzIHNlY3VyaXR5IHNvdW5kIHRvb2xzIHVzciB2
aXJ0IC5naXRpZ25vcmUgLm1haWxtYXAgJ2RlYmlhbi9idWlsZC9zb3VyY2UnCmNkICdkZWJpYW4v
YnVpbGQvc291cmNlJzsgcHl0aG9uICcvaG9tZS9zZC9zcmMvbGludXgtMi42L2xpbnV4LTIuNi4z
Ny1yYzUvZGViaWFuL2Jpbi9wYXRjaC5hcHBseScgLS1vdmVyd3JpdGUtaG9tZT0nL2hvbWUvc2Qv
c3JjL2xpbnV4LTIuNi9saW51eC0yLjYuMzctcmM1L2RlYmlhbi9wYXRjaGVzJwovaG9tZS9zZC9z
cmMvbGludXgtMi42L2xpbnV4LTIuNi4zNy1yYzUvZGViaWFuL2Jpbi9wYXRjaC5hcHBseTo4MTog
RGVwcmVjYXRpb25XYXJuaW5nOiBmdW5jdGlvbnMgb3ZlcnJpZGluZyB3YXJuaW5ncy5zaG93d2Fy
bmluZygpIG11c3Qgc3VwcG9ydCB0aGUgJ2xpbmUnIGFyZ3VtZW50CiAgd2FybignTm8gJXMgZmls
ZSwgYXNzdW1pbmcgRGViaWFuIExpbnV4ICVzJyAlIChzZWxmLl9maWxlLCB1cHN0cmVhbSkpCldh
cm5pbmc6IE5vIHZlcnNpb24uRGViaWFuIGZpbGUsIGFzc3VtaW5nIERlYmlhbiBMaW51eCAyLjYu
Mzd+cmM1Ci0tPiBUcnkgdG8gYXBwbHkgYmFzZS4KICAoKykgT0sgICBsaW51eC1uZXh0L3BhdGNo
LXYyLjYuMzctcmM1LW5leHQtMjAxMDEyMDgKICAoKykgT0sgICBsaW51eC1uZXh0LzAwMDEtUmVt
b3ZlLWxvY2FsdmVyc2lvbi1uZXh0LnBhdGNoCiAgKCspIE9LICAgZnJvbS1qb2hpbGwvMDAxLWRl
YnVnLXNlY3Rpb24tbWlzbWF0Y2gucGF0Y2gKICAoKykgT0sgICBwbGF0Zm9ybS14ODYtZml4L3Bs
YXRmb3JtLXg4Ni1LY29uZmlnLVJlcGxhY2Utc2VsZWN0LWJ5LWRlcGVuZHMtb24tQUNQSV9XTUku
cGF0Y2gKICAoKykgT0sgICB3cS1mb3ItbGludXMvd29ya3F1ZXVlLWNoZWNrLXRoZS1hbGxvY2F0
aW9uLW9mLXN5c3RlbV91bmJvdW5kX3dxLnBhdGNoCiAgKCspIE9LICAgbW0tZml4L2Nncm91cC1B
dm9pZC1hLW1lbXNldC1ieS11c2luZy12emFsbG9jLnBhdGNoCiAgKCspIE9LICAgbW0tZml4L2tt
ZW1sZWFrLXJlbW92ZS1tZW1zZXQtYnktdXNpbmcta3phbGxvYy5wYXRjaAogICgrKSBPSyAgIEFD
UEktUE0vMS0xMy1BQ1BJLVBNLUNoZWNrLWRldmljZS1zdGF0ZS1iZWZvcmUtcmVmY291bnRpbmct
cG93ZXItcmVzb3VyY2VzLnBhdGNoCiAgKCspIE9LICAgQUNQSS1QTS8yLTEzLUFDUEktUE0tRG8t
bm90LXJlZmNvdW50LXBvd2VyLXJlc291cmNlcy10aGF0LWNhbi10LWJlLXR1cm5lZC1vbi5wYXRj
aAogICgrKSBPSyAgIEFDUEktUE0vMy0xMy1BQ1BJLVBNLVByZXZlbnQtYWNwaV9wb3dlcl9nZXRf
aW5mZXJyZWRfc3RhdGUtZnJvbS1tYWtpbmctY2hhbmdlcy5wYXRjaAogICgrKSBPSyAgIEFDUEkt
UE0vNC0xMy1BQ1BJLVBNLUFkZC1mdW5jdGlvbnMtZm9yLW1hbmlwdWxhdGluZy1saXN0cy1vZi1w
b3dlci1yZXNvdXJjZXMucGF0Y2gKICAoKykgT0sgICBBQ1BJLVBNLzUtMTMtQUNQSS1QTS1JbnRy
b2R1Y2UtZnVuY3Rpb24tZm9yLXJlZmNvdW50aW5nLWRldmljZS1wb3dlci1yZXNvdXJjZXMucGF0
Y2gKICAoKykgT0sgICBBQ1BJLVBNLzYtMTMtQUNQSS1QTS1JbnRyb2R1Y2UtX19hY3BpX2J1c19n
ZXRfcG93ZXIucGF0Y2gKICAoKykgT0sgICBBQ1BJLVBNLzctMTMtQUNQSS1QTS1BZGQtZnVuY3Rp
b24tZm9yLWRldmljZS1wb3dlci1zdGF0ZS1pbml0aWFsaXphdGlvbi5wYXRjaAogICgrKSBPSyAg
IEFDUEktUE0vOC0xMy1BQ1BJLVBNLUFkZC1mdW5jdGlvbi1mb3ItdXBkYXRpbmctZGV2aWNlLXBv
d2VyLXN0YXRlLWNvbnNpc3RlbnRseS5wYXRjaAogICgrKSBPSyAgIEFDUEktUE0vOS0xMy1BQ1BJ
LVBNLVJlZ2lzdGVyLWFjcGlfcG93ZXJfZHJpdmVyLWVhcmx5LnBhdGNoCiAgKCspIE9LICAgQUNQ
SS1QTS8xMC0xMy1BQ1BJLVBNLVJlZ2lzdGVyLXBvd2VyLXJlc291cmNlLWRldmljZXMtYXMtc29v
bi1hcy10aGV5LWFyZS1uZWVkZWQucGF0Y2gKICAoKykgT0sgICBBQ1BJLVBNLzExLTEzLUFDUEkt
RmFuLVJld29yay10aGUtaGFuZGxpbmctb2YtcG93ZXItcmVzb3VyY2VzLnBhdGNoCiAgKCspIE9L
ICAgQUNQSS1QTS8xMi0xMy1BQ1BJLVBNLURyb3AtYWNwaV9idXNfZ2V0X3Bvd2VyLnBhdGNoCiAg
KCspIE9LICAgQUNQSS1QTS8xMy0xMy1BQ1BJLVBNLURyb3AtYWNwaV9wb3dlcl9ub2NoZWNrLnBh
dGNoCiAgKCspIE9LICAgQUNQSS1QTS1maXgvUGxhdGZvcm0teDg2LU1ha2UtZnVqaXRzdV9sYXB0
b3AtdXNlLWFjcGlfYnVzX3VwZGF0ZV9wb3dlci5wYXRjaAogICgrKSBPSyAgIHZmcy1zY2FsZS13
b3JraW5nL3Zmcy1zY2FsZS13b3JraW5nLnBhdGNoCiAgKCspIE9LICAgZnJvbS1ucGlnZ2luL2Zz
LW5hbWVpLWZpeC1ieS1ucGlnZ2luLXYyLWxpbnV4LW5leHQtMjAxMDEyMDgucGF0Y2gKICAoKykg
T0sgICBleHQ0LWZpeC9leHQ0LWZpeC1wb3NzaWJsZS1vdmVyZmxvdy1pbi1leHQ0X3RyaW1fZnMu
cGF0Y2gKICAoKykgT0sgICBkYW52ZXQtZHJtLWZvci1zZWRhdC1kaWxlay8wMDAxLWRybS1ub3V2
ZWF1LWRvbi10LW11bmdlLWluLWRybV9tbS1pbnRlcm5hbHMucGF0Y2gKICAoKykgT0sgICBkYW52
ZXQtZHJtLWZvci1zZWRhdC1kaWxlay8wMDAyLWRybV9tbS1hZGQtc3VwcG9ydC1mb3ItcmFuZ2Ut
cmVzdHJpY3RlZC1mYWlyLWxydS1zY2EucGF0Y2gKICAoKykgT0sgICBkYW52ZXQtZHJtLWZvci1z
ZWRhdC1kaWxlay8wMDAzLWRybS1tbS10cmFjay1mcmVlLWFyZWFzLWltcGxpY2l0bHkucGF0Y2gK
ICAoKykgT0sgICBkYW52ZXQtZHJtLWZvci1zZWRhdC1kaWxlay8wMDA0LWRybS1tbS1leHRyYWN0
LW5vZGUtaW5zZXJ0LWhlbHBlci1mdW5jdGlvbnMucGF0Y2gKICAoKykgT0sgICBkYW52ZXQtZHJt
LWZvci1zZWRhdC1kaWxlay8wMDA1LWRybS1tbS1hZGQtYXBpLWZvci1lbWJlZGRpbmctc3RydWN0
LWRybV9tbV9ub2RlLnBhdGNoCiAgKCspIE9LICAgZGFudmV0LWRybS1mb3Itc2VkYXQtZGlsZWsv
MDAwNi1kcm0tbW0tYWRkLWhlbHBlci10by11bndpbmQtc2Nhbi1zdGF0ZS5wYXRjaAogICgrKSBP
SyAgIGRhbnZldC1lbWJlZC1kcm1fZ2VtX29iamVjdC1pbnRvLXJhZGVvbl9iby8xLTMtZHJtLXJh
ZGVvbi1lbWJlZC1zdHJ1Y3QtZHJtX2dlbV9vYmplY3QucGF0Y2gKICAoKykgT0sgICBkYW52ZXQt
ZW1iZWQtZHJtX2dlbV9vYmplY3QtaW50by1yYWRlb25fYm8vMi0zLWRybS1yYWRlb24taW50cm9k
dWNlLWdlbV90b19yYWRlb25fYm8taGVscGVyLnBhdGNoCiAgKCspIE9LICAgZGFudmV0LWVtYmVk
LWRybV9nZW1fb2JqZWN0LWludG8tcmFkZW9uX2JvLzMtMy1kcm0tcmFkZW9uLWtpbGwtcmFkZW9u
X2JvLS1nb2JqLXBvaW50ZXIucGF0Y2gKICAoKykgT0sgICBkYW52ZXQtcmFkZW9uLWFzaWMtaGVh
ZGVyLWNsZWFudXAtMi8xLTctcmFkZW9uLWNvbnNvbGlkYXRlLWFzaWMtc3BlY2lmaWMtZnVuY3Rp
b24tZGVjbHMtZm9yLXByZS1yNjAwLnBhdGNoCiAgKCspIE9LICAgZGFudmV0LXJhZGVvbi1hc2lj
LWhlYWRlci1jbGVhbnVwLTIvMi03LXJhZGVvbi1jb25zb2xpZGF0ZS1hc2ljLXNwZWNpZmljLWZ1
bmN0aW9uLWRlY2xzLWZvci1yNjAwLWxhdGVyLnBhdGNoCiAgKCspIE9LICAgZGFudmV0LXJhZGVv
bi1hc2ljLWhlYWRlci1jbGVhbnVwLTIvMy03LXJhZGVvbi1kcm9wLWV4dGVybi1mcm9tLWZ1bmN0
aW9uLWRlY2xzLnBhdGNoCiAgKCspIE9LICAgZGFudmV0LXJhZGVvbi1hc2ljLWhlYWRlci1jbGVh
bnVwLTIvNC03LXJhZGVvbi1raWxsLWRlY2xzLWZvci1pbmxpbmUtZnVuY3Rpb25zLnBhdGNoCiAg
KCspIE9LICAgZGFudmV0LXJhZGVvbi1hc2ljLWhlYWRlci1jbGVhbnVwLTIvNS03LXJhZGVvbi1t
b3ZlLWJsaXQtZnVuY3Rpb25zLXRvLXJhZGVvbl9hc2ljLmgucGF0Y2gKICAoKykgT0sgICBkYW52
ZXQtcmFkZW9uLWFzaWMtaGVhZGVyLWNsZWFudXAtMi82LTctcmFkZW9uLWtpbGwtcjEwMF9pb18t
ci13LXJlZy5wYXRjaAogICgrKSBPSyAgIGRhbnZldC1yYWRlb24tYXNpYy1oZWFkZXItY2xlYW51
cC0yLzctNy1yYWRlb24ta2lsbC1yZGV2LS1wY2llcF8tci13LXJlZy5wYXRjaAogICgrKSBPSyAg
IGZvci1kcm0tcmFkZW9uLXRlc3RpbmcvZHJtLXJhZGVvbi1rbXMtZW5hYmxlLXdyaXRlYmFjay1v
bi1yYWRlb24tQUdQLWJvYXJkcy5wYXRjaAogICgrKSBPSyAgIGRyaS1kZXZlbC9kcm0tcmFkZW9u
LWttcy1pbXByb3ZlLXBmbGlwLXByZWNpc2lvbi1vbi1yMXh4LXI0eHgucGF0Y2gKICAoKykgT0sg
ICBkcmktZGV2ZWwvZHJtLUFkZC1taXNzaW5nLWRybV92YmxhbmtfcHV0LWFsb25nLXF1ZXVlLXZi
bGFuay1lcnJvci1wYXRoLnBhdGNoCiAgKCspIE9LICAgYXRoNWstZml4LzAwMDEtYXRoNWstRml4
LW1vZGluZm8tZG9lcy1ub3QtbGlzdC1hbGlhcy1wY2ktaWQtbGluZXMucGF0Y2gKICAoKykgT0sg
ICBkZWJpYW4vdmVyc2lvbi5wYXRjaAogICgrKSBPSyAgIGRlYmlhbi9rZXJuZWx2YXJpYWJsZXMt
Mi42LjM3LnBhdGNoCiAgKCspIE9LICAgZGViaWFuL2RvYy1idWlsZC1wYXJhbGxlbC5wYXRjaAog
ICgrKSBPSyAgIGJ1Z2ZpeC9pYTY0L2hhcmRjb2RlLWFyY2gtc2NyaXB0LW91dHB1dC5wYXRjaAog
ICgrKSBPSyAgIGJ1Z2ZpeC9taXBzL2Rpc2FibGUtYWR2YW5zeXMucGF0Y2gKICAoKykgT0sgICBi
dWdmaXgvYXJtL2Rpc2FibGUtc2NzaV9hY2FyZC5wYXRjaAogICgrKSBPSyAgIGRlYmlhbi9taXBz
LWRpc2FibGUtd2Vycm9yLnBhdGNoCiAgKCspIE9LICAgYnVnZml4L3Bvd2VycGMvbHBhci1jb25z
b2xlLnBhdGNoCiAgKCspIE9LICAgZmVhdHVyZXMvYWxsL2k5MTUtYXV0b2xvYWQtd2l0aG91dC1D
T05GSUdfRFJNX0k5MTVfS01TLnBhdGNoCiAgKCspIE9LICAgZGViaWFuL2FyY2gtc2g0LWZpeC11
aW1hZ2UtYnVpbGQucGF0Y2gKICAoKykgT0sgICBidWdmaXgvbWlwcy9taXBzLWlkZS1mbHVzaC1k
Y2FjaGUucGF0Y2gKICAoKykgT0sgICBidWdmaXgvYWxsL3FsYTR4eHgtRml4LWJ1aWxkLW9uLXNv
bWUtYXJjaGl0ZWN0dXJlcy1sYWNraW5nLTY0LWJpdC1JLU8ucGF0Y2gKICAoKykgT0sgICBidWdm
aXgveDg2L1NraXAtbG9va2luZy1mb3ItaW9hcGljLW92ZXJyaWRlcy13aGVuLWlvYXBpY3MtYXJl
LW5vdC1wcmVzZW50LnBhdGNoCi0tPiBiYXNlIGZ1bGx5IGFwcGxpZWQuCiMgU3VwcHJlc3MgdHJh
aWxpbmcgJysnIGluIHV0c3JlbGVhc2UKdG91Y2ggJ2RlYmlhbi9idWlsZC9zb3VyY2UvLnNjbXZl
cnNpb24nCnJtIC1yZiAnZGViaWFuL2J1aWxkL3NvdXJjZV9pMzg2X25vbmUnCmNwIC1hbCAnZGVi
aWFuL2J1aWxkL3NvdXJjZScgJ2RlYmlhbi9idWlsZC9zb3VyY2VfaTM4Nl9ub25lJwpjZCAnZGVi
aWFuL2J1aWxkL3NvdXJjZV9pMzg2X25vbmUnOyBweXRob24gJy9ob21lL3NkL3NyYy9saW51eC0y
LjYvbGludXgtMi42LjM3LXJjNS9kZWJpYW4vYmluL3BhdGNoLmFwcGx5JyAtLW92ZXJ3cml0ZS1o
b21lPScvaG9tZS9zZC9zcmMvbGludXgtMi42L2xpbnV4LTIuNi4zNy1yYzUvZGViaWFuL3BhdGNo
ZXMnIC1hIGkzODYgLWYgbm9uZQotLT4gVHJ5IHRvIGFwcGx5IGJhc2UtZXh0cmEuCi0tPiBiYXNl
LWV4dHJhIGZ1bGx5IGFwcGxpZWQuCnB5dGhvbiBkZWJpYW4vYmluL2tjb25maWcucHkgJ2RlYmlh
bi9idWlsZC9jb25maWcuaTM4Nl9ub25lXzY4NicgZGViaWFuL2NvbmZpZy9jb25maWcgZGViaWFu
L2NvbmZpZy9rZXJuZWxhcmNoLXg4Ni9jb25maWcgZGViaWFuL2NvbmZpZy9rZXJuZWxhcmNoLXg4
Ni9jb25maWctYXJjaC0zMiBkZWJpYW4vY29uZmlnL2kzODYvbm9uZS9jb25maWcuNjg2IApybSAt
cmYgJ2RlYmlhbi9idWlsZC9idWlsZF9pMzg2X25vbmVfNjg2Jwpta2RpciAnZGViaWFuL2J1aWxk
L2J1aWxkX2kzODZfbm9uZV82ODYnCmNwICdkZWJpYW4vYnVpbGQvY29uZmlnLmkzODZfbm9uZV82
ODYnICdkZWJpYW4vYnVpbGQvYnVpbGRfaTM4Nl9ub25lXzY4Ni8uY29uZmlnJwplY2hvICctNjg2
JyA+ICdkZWJpYW4vYnVpbGQvYnVpbGRfaTM4Nl9ub25lXzY4Ni9sb2NhbHZlcnNpb24nCmVjaG8g
J292ZXJyaWRlIEFSQ0ggPSB4ODYnID4+ICdkZWJpYW4vYnVpbGQvYnVpbGRfaTM4Nl9ub25lXzY4
Ni8ua2VybmVsdmFyaWFibGVzJwplY2hvICdDQ0FDSEUgPSBjY2FjaGUnID4+ICdkZWJpYW4vYnVp
bGQvYnVpbGRfaTM4Nl9ub25lXzY4Ni8ua2VybmVsdmFyaWFibGVzJwplY2hvICdDQyA9ICQoaWYg
JChERUJJQU5fS0VSTkVMX1VTRV9DQ0FDSEUpLCQoQ0NBQ0hFKSkgJChDUk9TU19DT01QSUxFKWdj
Yy00LjQnID4+ICdkZWJpYW4vYnVpbGQvYnVpbGRfaTM4Nl9ub25lXzY4Ni8ua2VybmVsdmFyaWFi
bGVzJwplY2hvICdpZm5lcSAoJChERUJfQlVJTERfQVJDSCksJChERUJfSE9TVF9BUkNIKSknID4+
ICdkZWJpYW4vYnVpbGQvYnVpbGRfaTM4Nl9ub25lXzY4Ni8ua2VybmVsdmFyaWFibGVzJwplY2hv
ICdvdmVycmlkZSBDUk9TU19DT01QSUxFID0gJChERUJfSE9TVF9HTlVfVFlQRSktJyA+PiAnZGVi
aWFuL2J1aWxkL2J1aWxkX2kzODZfbm9uZV82ODYvLmtlcm5lbHZhcmlhYmxlcycKZWNobyAnZW5k
aWYnID4+ICdkZWJpYW4vYnVpbGQvYnVpbGRfaTM4Nl9ub25lXzY4Ni8ua2VybmVsdmFyaWFibGVz
JwplbnYgLXUgQUJJTkFNRSAtdSBBUkNIIC11IEZFQVRVUkVTRVQgLXUgRkxBVk9VUiAtdSBWRVJT
SU9OIC11IExPQ0FMVkVSU0lPTiBESVNUUklCVVRJT05fT0ZGSUNJQUxfQlVJTEQ9MSBESVNUUklC
VVRJT05fVVBMT0FERVI9c2VkYXQuZGlsZWtAZ21haWwuY29tIERJU1RSSUJVVElPTl9WRVJTSU9O
PSIyLjYuMzd+cmM1LTF+bmV4dDIwMTAxMjA4LmRpbGVrcy4xIiBtYWtlIC1DICdkZWJpYW4vYnVp
bGQvc291cmNlX2kzODZfbm9uZScgTz0nL2hvbWUvc2Qvc3JjL2xpbnV4LTIuNi9saW51eC0yLjYu
MzctcmM1L2RlYmlhbi9idWlsZC9idWlsZF9pMzg2X25vbmVfNjg2JyBvbGRub2NvbmZpZwptYWtl
WzJdOiBFbnRlcmluZyBkaXJlY3RvcnkgYC9ob21lL3NkL3NyYy9saW51eC0yLjYvbGludXgtMi42
LjM3LXJjNS9kZWJpYW4vYnVpbGQvc291cmNlX2kzODZfbm9uZScKICBIT1NUQ0MgIHNjcmlwdHMv
YmFzaWMvZml4ZGVwCiAgSE9TVENDICBzY3JpcHRzL2Jhc2ljL2RvY3Byb2MKICBHRU4gICAgIC9o
b21lL3NkL3NyYy9saW51eC0yLjYvbGludXgtMi42LjM3LXJjNS9kZWJpYW4vYnVpbGQvYnVpbGRf
aTM4Nl9ub25lXzY4Ni9NYWtlZmlsZQogIEhPU1RDQyAgc2NyaXB0cy9rY29uZmlnL2NvbmYubwog
IEhPU1RDQyAgc2NyaXB0cy9rY29uZmlnL2t4Z2V0dGV4dC5vCiAgU0hJUFBFRCBzY3JpcHRzL2tj
b25maWcvemNvbmYudGFiLmMKICBTSElQUEVEIHNjcmlwdHMva2NvbmZpZy9sZXguemNvbmYuYwog
IFNISVBQRUQgc2NyaXB0cy9rY29uZmlnL3pjb25mLmhhc2guYwogIEhPU1RDQyAgc2NyaXB0cy9r
Y29uZmlnL3pjb25mLnRhYi5vCiAgSE9TVExEICBzY3JpcHRzL2tjb25maWcvY29uZgpzY3JpcHRz
L2tjb25maWcvY29uZiAtLW9sZG5vY29uZmlnIEtjb25maWcKIwojIGNvbmZpZ3VyYXRpb24gd3Jp
dHRlbiB0byAuY29uZmlnCiMKbWFrZVsyXTogTGVhdmluZyBkaXJlY3RvcnkgYC9ob21lL3NkL3Ny
Yy9saW51eC0yLjYvbGludXgtMi42LjM3LXJjNS9kZWJpYW4vYnVpbGQvc291cmNlX2kzODZfbm9u
ZScKZW52IC11IEFCSU5BTUUgLXUgQVJDSCAtdSBGRUFUVVJFU0VUIC11IEZMQVZPVVIgLXUgVkVS
U0lPTiAtdSBMT0NBTFZFUlNJT04gRElTVFJJQlVUSU9OX09GRklDSUFMX0JVSUxEPTEgRElTVFJJ
QlVUSU9OX1VQTE9BREVSPXNlZGF0LmRpbGVrQGdtYWlsLmNvbSBESVNUUklCVVRJT05fVkVSU0lP
Tj0iMi42LjM3fnJjNS0xfm5leHQyMDEwMTIwOC5kaWxla3MuMSIgbWFrZSAtQyAnZGViaWFuL2J1
aWxkL3NvdXJjZV9pMzg2X25vbmUnIE89Jy9ob21lL3NkL3NyYy9saW51eC0yLjYvbGludXgtMi42
LjM3LXJjNS9kZWJpYW4vYnVpbGQvYnVpbGRfaTM4Nl9ub25lXzY4NicgIHByZXBhcmUKbWFrZVsy
XTogRW50ZXJpbmcgZGlyZWN0b3J5IGAvaG9tZS9zZC9zcmMvbGludXgtMi42L2xpbnV4LTIuNi4z
Ny1yYzUvZGViaWFuL2J1aWxkL3NvdXJjZV9pMzg2X25vbmUnCiAgR0VOICAgICAvaG9tZS9zZC9z
cmMvbGludXgtMi42L2xpbnV4LTIuNi4zNy1yYzUvZGViaWFuL2J1aWxkL2J1aWxkX2kzODZfbm9u
ZV82ODYvTWFrZWZpbGUKc2NyaXB0cy9rY29uZmlnL2NvbmYgLS1zaWxlbnRvbGRjb25maWcgS2Nv
bmZpZwogIFVzaW5nIC9ob21lL3NkL3NyYy9saW51eC0yLjYvbGludXgtMi42LjM3LXJjNS9kZWJp
YW4vYnVpbGQvc291cmNlX2kzODZfbm9uZSBhcyBzb3VyY2UgZm9yIGtlcm5lbAogIEdFTiAgICAg
L2hvbWUvc2Qvc3JjL2xpbnV4LTIuNi9saW51eC0yLjYuMzctcmM1L2RlYmlhbi9idWlsZC9idWls
ZF9pMzg2X25vbmVfNjg2L01ha2VmaWxlCiAgQ0hLICAgICBpbmNsdWRlL2xpbnV4L3ZlcnNpb24u
aAogIFVQRCAgICAgaW5jbHVkZS9saW51eC92ZXJzaW9uLmgKICBDSEsgICAgIGluY2x1ZGUvZ2Vu
ZXJhdGVkL3V0c3JlbGVhc2UuaAogIFVQRCAgICAgaW5jbHVkZS9nZW5lcmF0ZWQvdXRzcmVsZWFz
ZS5oCiAgQ0MgICAgICBrZXJuZWwvYm91bmRzLnMKICBHRU4gICAgIGluY2x1ZGUvZ2VuZXJhdGVk
L2JvdW5kcy5oCiAgQ0MgICAgICBhcmNoL3g4Ni9rZXJuZWwvYXNtLW9mZnNldHMucwogIEdFTiAg
ICAgaW5jbHVkZS9nZW5lcmF0ZWQvYXNtLW9mZnNldHMuaAogIENBTEwgICAgL2hvbWUvc2Qvc3Jj
L2xpbnV4LTIuNi9saW51eC0yLjYuMzctcmM1L2RlYmlhbi9idWlsZC9zb3VyY2VfaTM4Nl9ub25l
L3NjcmlwdHMvY2hlY2tzeXNjYWxscy5zaAptYWtlWzJdOiBMZWF2aW5nIGRpcmVjdG9yeSBgL2hv
bWUvc2Qvc3JjL2xpbnV4LTIuNi9saW51eC0yLjYuMzctcmM1L2RlYmlhbi9idWlsZC9zb3VyY2Vf
aTM4Nl9ub25lJwptYWtlWzFdOiBMZWF2aW5nIGRpcmVjdG9yeSBgL2hvbWUvc2Qvc3JjL2xpbnV4
LTIuNi9saW51eC0yLjYuMzctcmM1Jwo=
--0016363b85209045fa0496e310e6--
