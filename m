Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab0FKGhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:37:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55738 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0FKGhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Pr/K/8j/PQbEEXy1jigAtMQHfT7ZkNNKttiPciGo9iztgNqrldWifG9mwxW36AyCVE
         cpcgNxOl166yUIPEuS6pCjN26GhZU6ZkP+GUFJtZU4kb21ZzIFaY1EGFXoPHBVGQ/4Sz
         6UwAKp8NMfSryM8qwO3RernSyWD8OwVS7jPPg=
Message-ID: <4C11D971.1020300@gmail.com>
Date: Thu, 10 Jun 2010 23:36:33 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]script:conf.c Fix warning: variable 'type' set but not
 used
References: <1276233832-17193-1-git-send-email-justinmattock@gmail.com> <20100611063056.GD6864@basil.fritz.box>
In-Reply-To: <20100611063056.GD6864@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 11:30 PM, Andi Kleen wrote:
>> I get this using gcc 4.6.0 the below change fixes this form me.
>> (not sure with earlier version of gcc).
>> please have a look and let me know.
>
>> From a quick look it's likely correct, but you really need
> to send this to the Kconfig maintainer, not to me.
>
> -Andi
>

alright.. I've another one
(hopefully right), so I'll just
go through the list of warnings
then with what I get out of i'll
compose a list of cc's/patches to the
appropriate person.

Justin P. Mattock
