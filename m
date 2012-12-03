Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2LCX2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:28:08 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:34228 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2LCX2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:28:06 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2012 18:28:06 EST
MIME-Version: 1.0
In-Reply-To: <CAK5ve-K3aEd57xV_pL36V5sL0FEhp4cWh0DX9zO1j9s1C+j_zg@mail.gmail.com>
References: <1354312850-29264-1-git-send-email-marek.belisko@open-nandra.com>
	<1354312850-29264-2-git-send-email-marek.belisko@open-nandra.com>
	<CAK5ve-K3aEd57xV_pL36V5sL0FEhp4cWh0DX9zO1j9s1C+j_zg@mail.gmail.com>
Date: Tue, 4 Dec 2012 00:21:26 +0100
Message-ID: <CAAfyv37ic0GT65aD3wTpY7K=Y5jyOfnZ-ruSvb0zgf=xJgh-ig@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] Add documentation for tca6507 devicetree bindings.
From: Belisko Marek <marek.belisko@gmail.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: rpurdie@rpsys.net, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 8:29 PM, Bryan Wu <cooloney@gmail.com> wrote:
> On Fri, Nov 30, 2012 at 2:00 PM, Marek Belisko
> <marek.belisko@open-nandra.com> wrote:
>> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
>> ---
>>  Documentation/devicetree/bindings/leds/tca6507.txt |   33 ++++++++++++++++++++
>>  1 file changed, 33 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/leds/tca6507.txt
>>
>> diff --git a/Documentation/devicetree/bindings/leds/tca6507.txt b/Documentation/devicetree/bindings/leds/tca6507.txt
>> new file mode 100644
>> index 0000000..2b6693b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/leds/tca6507.txt
>> @@ -0,0 +1,33 @@
>> +LEDs conected to tca6507
>> +
>> +Required properties:
>> +- compatible : should be : "ti,tca6507".
>> +
>> +Each led is represented as a sub-node of the ti,tca6507 device.
>> +
>> +LED sub-node properties:
>> +- label : (optional) see Documentation/devicetree/bindings/leds/common.txt
>> +- reg : number of LED line (could be from 0 to 6)
>> +- linux,default-trigger : (optional)
>> +   see Documentation/devicetree/bindings/leds/common.txt
>
> Did you post patch to add this file? I failed to find it and overall
> this patchset looks fine with me.
Yes. I'ts in current next.
https://lkml.org/lkml/2012/11/21/394
>
> -Bryan
>
>> +
>> +Examples:
>> +
>> +tca6507@45 {
>> +       compatible = "ti,tca6507";
>> +       #address-cells = <1>;
>> +       #size-cells = <0>;
>> +       reg = <0x45>;
>> +
>> +       led0: red-aux@0 {
>> +               label = "red:aux";
>> +               reg = <0x0>;
>> +       };
>> +
>> +       led1: green-aux@1 {
>> +               label = "green:aux";
>> +               reg = <0x5>;
>> +               linux,default-trigger = "default-on";
>> +       };
>> +};
>> +
>> --
>> 1.7.10.4
>>

Marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
