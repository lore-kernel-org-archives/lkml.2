Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0KCKlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:41:53 -0400
Received: from mognix.dark-green.com ([88.116.226.179]:64302 "EHLO
	mognix.dark-green.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab0KCKlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:41:52 -0400
MIME-Version: 1.0
Date: Wed, 03 Nov 2010 11:41:49 +0100
From: gimli <gimli@dark-green.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: <linux-kernel@vger.kernel.org>
Subject: Resend: [PATCH 1/6] MacBookAir3,1(3,2) applesmc support
In-Reply-To: <4CD137AF.30206@euromail.se>
References: <cf611abb8b842b043fd6e837cf161a39@mognix.dark-green.com> <4CD03FB0.8000605@euromail.se> <16daf2365a63093624c93857a0011008@mognix.dark-green.com> <4CD137AF.30206@euromail.se>
Message-ID: <3b7fc6c1e0318f1100afc442d52da18c@mognix.dark-green.com>
User-Agent: RoundCube Webmail/0.2.2
Content-Type: multipart/mixed;
	boundary="=_7da23b07986ca1848008dcbb868d7c46"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=_7da23b07986ca1848008dcbb868d7c46
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"

Typo fixed patch.

Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>

On Wed, 03 Nov 2010 11:21:35 +0100, Henrik Rydberg <rydberg@euromail.se>
wrote:
> On 11/03/2010 10:39 AM, gimli wrote:
> 
>> On Tue, 02 Nov 2010 17:43:28 +0100, Henrik Rydberg <rydberg@euromail.se>
>> wrote:
>>> On 11/02/2010 08:17 AM, gimli wrote:
>>>
>>>> This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the
>>>> applesmc driver.
>>>>
>>>> Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
>>>
>>>
>>> Thanks for this information. The patch is conflicting with a makeover
>>> currently
>>> on review, but it is a candidate for inclusion in 2.6.37 and stable.
>>>
>>>>  /* List of keys used to read/write fan speeds */
>>>> @@ -1524,11 +1528,21 @@
>>>>  	{ .accelerometer = 1, .light = 1, .temperature_set = 21 },
>>>>  /* MacBook Pro 7,1: accelerometer, backlight and temperature set 22
*/
>>>>  	{ .accelerometer = 1, .light = 1, .temperature_set = 22 },
>>>> +/* MacBook Air 3,1: accelerometer, backlight and temperature set 15
*/
>>>> +	{ .accelerometer = 0, .light = 0, .temperature_set = 23 },
>>>>  };
>>>
>>> Comment "temperature set 15" is confusing.
>>>
>> 
>> This is a copy and paste error. Should be :
>> 
>> +/* MacBook Air 3,1(2): temperature set 23 */
>> 
>> 
>> 
>>>>  /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
>>>>   * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
>>>>  static __initdata struct dmi_system_id applesmc_whitelist[] = {
>>>> +	{ applesmc_dmi_match, "Apple MacBook Air 3", {
>>>> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
>>>> +	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,2") },
>>>> +		&applesmc_dmi_data[23]},
>>>> +	{ applesmc_dmi_match, "Apple MacBook Air 3", {
>>>> +	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
>>>> +	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,1") },
>>>> +		&applesmc_dmi_data[23]},
>>>
>>> What is the different between models 3,1 and 3,2? If there is no
>>> difference, a
>>> single entry will suffice.
>> 
>> They are both the same.
> 
> 
> Great - would you care to resend the patch with the changes incorporated?
> 
> Thanks,
> Henrik
--=_7da23b07986ca1848008dcbb868d7c46
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="UTF-8";
 name="applesmc_macnbookair.patch"; 
Content-Disposition: attachment;
 filename="applesmc_macnbookair.patch"; 

ZGlmZiAtdU5yIGxpbnV4LTIuNi4zNS9kcml2ZXJzL2h3bW9uL2FwcGxlc21jLmMgbGludXgtMi42
LjM1LU1hY2Jvb2tBaXIvZHJpdmVycy9od21vbi9hcHBsZXNtYy5jCi0tLSBsaW51eC0yLjYuMzUv
ZHJpdmVycy9od21vbi9hcHBsZXNtYy5jCTIwMTAtMDgtMDIgMDA6MTE6MTQuMDAwMDAwMDAwICsw
MjAwCisrKyBsaW51eC0yLjYuMzUtTWFjYm9va0Fpci9kcml2ZXJzL2h3bW9uL2FwcGxlc21jLmMJ
MjAxMC0xMC0yNCAwNzo0NTowMi4wODU2NzkwMDIgKzAyMDAKQEAgLTE2Miw2ICsxNjIsMTAgQEAK
IC8qIFNldCAyMjogTWFjQm9vayBQcm8gNywxICovCiAJeyAiVEIwVCIsICJUQjFUIiwgIlRCMlQi
LCAiVEMwRCIsICJUQzBQIiwgIlROMEQiLCAiVE4wUCIsICJUTjBTIiwKIAkgICJUTjFEIiwgIlRO
MUYiLCAiVE4xRyIsICJUTjFTIiwgIlRoMUgiLCAiVHMwUCIsICJUczBTIiwgTlVMTCB9LAorLyog
U2V0IDIzOiBNYWNCb29rIEFpciAzLDEoMikgKi8KKwl7ICJUQjBUIiwgIlRCMVQiLCAiVEIyVCIs
ICJUQzBEIiwgIlRDMEUiLCAiVEMwUCIsICJUQzFFIiwgIlRDWjMiLAorCSAgIlRDWjQiLCAiVENa
NSIsICJURzBFIiwgIlRHMUUiLCAiVEcyRSIsICJUR1ozIiwgIlRHWjQiLCAiVEdaNSIsCisJICAi
VEgwRiIsICJUSDBPIiwgIlRNMFAiIH0sCiB9OwogCiAvKiBMaXN0IG9mIGtleXMgdXNlZCB0byBy
ZWFkL3dyaXRlIGZhbiBzcGVlZHMgKi8KQEAgLTE1MjQsMTEgKzE1MjgsMjEgQEAKIAl7IC5hY2Nl
bGVyb21ldGVyID0gMSwgLmxpZ2h0ID0gMSwgLnRlbXBlcmF0dXJlX3NldCA9IDIxIH0sCiAvKiBN
YWNCb29rIFBybyA3LDE6IGFjY2VsZXJvbWV0ZXIsIGJhY2tsaWdodCBhbmQgdGVtcGVyYXR1cmUg
c2V0IDIyICovCiAJeyAuYWNjZWxlcm9tZXRlciA9IDEsIC5saWdodCA9IDEsIC50ZW1wZXJhdHVy
ZV9zZXQgPSAyMiB9LAorLyogTWFjQm9vayBBaXIgMywxKDIpOiB0ZW1wZXJhdHVyZSBzZXQgMjMg
Ki8KKwl7IC5hY2NlbGVyb21ldGVyID0gMCwgLmxpZ2h0ID0gMCwgLnRlbXBlcmF0dXJlX3NldCA9
IDIzIH0sCiB9OwogCiAvKiBOb3RlIHRoYXQgRE1JX01BVENIKC4uLiwiTWFjQm9vayIpIHdpbGwg
bWF0Y2ggIk1hY0Jvb2tQcm8xLDEiLgogICogU28gd2UgbmVlZCB0byBwdXQgIkFwcGxlIE1hY0Jv
b2sgUHJvIiBiZWZvcmUgIkFwcGxlIE1hY0Jvb2siLiAqLwogc3RhdGljIF9faW5pdGRhdGEgc3Ry
dWN0IGRtaV9zeXN0ZW1faWQgYXBwbGVzbWNfd2hpdGVsaXN0W10gPSB7CisJeyBhcHBsZXNtY19k
bWlfbWF0Y2gsICJBcHBsZSBNYWNCb29rIEFpciAzIiwgeworCSAgRE1JX01BVENIKERNSV9CT0FS
RF9WRU5ET1IsICJBcHBsZSIpLAorCSAgRE1JX01BVENIKERNSV9QUk9EVUNUX05BTUUsICJNYWNC
b29rQWlyMywyIikgfSwKKwkJJmFwcGxlc21jX2RtaV9kYXRhWzIzXX0sCisJeyBhcHBsZXNtY19k
bWlfbWF0Y2gsICJBcHBsZSBNYWNCb29rIEFpciAzIiwgeworCSAgRE1JX01BVENIKERNSV9CT0FS
RF9WRU5ET1IsICJBcHBsZSIpLAorCSAgRE1JX01BVENIKERNSV9QUk9EVUNUX05BTUUsICJNYWNC
b29rQWlyMywxIikgfSwKKwkJJmFwcGxlc21jX2RtaV9kYXRhWzIzXX0sCiAJeyBhcHBsZXNtY19k
bWlfbWF0Y2gsICJBcHBsZSBNYWNCb29rIEFpciAyIiwgewogCSAgRE1JX01BVENIKERNSV9CT0FS
RF9WRU5ET1IsICJBcHBsZSIpLAogCSAgRE1JX01BVENIKERNSV9QUk9EVUNUX05BTUUsICJNYWNC
b29rQWlyMiIpIH0sCg==
--=_7da23b07986ca1848008dcbb868d7c46--

