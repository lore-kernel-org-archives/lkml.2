Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179Ab2J3Rrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:47:43 -0400
Received: from fep15.mx.upcmail.net ([62.179.121.35]:33054 "EHLO
	fep15.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965014Ab2J3Rrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:47:42 -0400
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <509012B8.1010706@odi.ch>
Date: Tue, 30 Oct 2012 18:47:36 +0100
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>, bskeggs@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: drm/nouveau: crash regression in 3.5
References: <500ED9EC.5040309@odi.ch> <20120724205746.GA8707@joi.lan> <500FB279.1020904@odi.ch> <20120725184205.GA3119@joi.lan> <50113E76.9090706@odi.ch> <20120729201532.GA3566@joi.lan> <50166D15.7090305@odi.ch> <20120730171629.GA3271@joi.lan> <50194F7B.7040401@odi.ch> <501A63FF.8030503@odi.ch> <20120802165630.GA3058@joi.lan>
In-Reply-To: <20120802165630.GA3058@joi.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.2012 18:56, Marcin Slusarz wrote:
> On Thu, Aug 02, 2012 at 01:26:55PM +0200, Ortwin Glück wrote:
>> I have managed to turn the crash into a WARN_ON, by adding this to the
>> begin of nouveau_software_vblank():
>>
>>           if (!psw) {
>>                   WARN_ON(1);
>>                   return;
>>           }
>
> Yes, I know about it, but this change fixes only a symptom. We should not get
> into this code at all without enabling vblank.

I was wondering if that is ever going to be fixed in stable. Nouveau is 
broken due to this bug in 3.5 and 3.6 on HP laptops -- not terribly 
exotic hardware, is it? Is there any reason why this should not be 
submitted to stable?

Ortwin

