Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab1CYHGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:06:09 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36103 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab1CYHGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:06:04 -0400
X-Greylist: delayed 36742 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Mar 2011 03:06:04 EDT
X-Originating-IP: 217.70.178.129
X-Originating-IP: 134.134.137.73
Message-ID: <4D8C3ED1.5000704@pbjtriplett.org>
Date: Fri, 25 Mar 2011 00:05:53 -0700
From: Burt Triplett <burt@pbjtriplett.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org
Subject: Re: BITS handling of CPU microcode updates
References: <4D65EE74.1050709@pbjtriplett.org>	<20110312023001.GB27550@khazad-dum.debian.net>	<4D87E2CD.6020306@pbjtriplett.org>	<20110324001451.GA7950@khazad-dum.debian.net> <m2ipv8kx8y.fsf@firstfloor.org>
In-Reply-To: <m2ipv8kx8y.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/24/2011 2:46 PM, Andi Kleen wrote:
> Henrique de Moraes Holschuh<hmh@hmh.eng.br>  writes:
>>
>> Very well, I will send patches to fix that behaviour, as well as some
>> other stuff I noticed that was not updated to match the recommended
>> actions documented by the SDM and some Intel application notes.
>
> I don't think you can easily -- there's no kernel interface
> to distingush the "explicit user action" case from automatic loading.

Correct, but the microcode module can still implement the "automatic 
loading" case, as Henrique's patch does.

> I suppose all the test labs have learned by now how to disable
> automatic updates ...

The microcode driver's current unsigned revision checking happens to 
treat negative revisions as large positive revisions, so it happened to 
work OK in the test lab environments, though not by design. :)

- Burt Triplett
