Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab0JYJIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:08:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43453 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab0JYJIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:08:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=v200orj+OQJl7XLYPB2k8kAC8NSViB2GFJhArdM+yprVmGp+qaZzZ4FysIW6vMc4ss
         khXlCSvqDLgooREEzre0mAkulsXGr1ru1qh371g07mU3DobpqbVBRc763OuOLLHhRD4x
         UqU5sWsBTF84BKQMwwmPC3iVkCwx7FLsUdiLQ=
Message-ID: <4CC548F8.1090307@gmail.com>
Date: Mon, 25 Oct 2010 11:08:08 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: kevin granade <kevin.granade@gmail.com>,
        "Artem S. Tashkinov" <t.artem@lycos.com>, linux-kernel@vger.kernel.org
Subject: Re: On Linux numbering scheme
References: <18536664.253751287691209904.JavaMail.root@mail-zbox20.bo3.lycos.com> <28654042.253821287691362834.JavaMail.root@mail-zbox20.bo3.lycos.com> <AANLkTimqNW7zArcjtOkBvrn-dk=YE0_RG+u3yoMDTjwV@mail.gmail.com> <20101022020006.GF19804@ZenIV.linux.org.uk>
In-Reply-To: <20101022020006.GF19804@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 04:00 AM, Al Viro wrote:
> On Thu, Oct 21, 2010 at 07:06:23PM -0500, kevin granade wrote:
> 
>> Any particular reason not to continue the date-oriented format and
>> have the third number be the numerical representation of the month
>> rather than an incrementing numbering of the releases?  It would still
>> be monotonically increasing, which is the only requirement, right?
> 
> Why do we need to change it, anyway?

Agreed.  These days, I use just the last digit, as in kernel 36, in
casual contexts.  It's a number as good as any other.  I don't think
it needs to be changed actively.  If the 2.6. prefix is bothering,
just use the last number and maybe that will become semi-official in
the future, or maybe not.  Doesn't really matter.

-- 
tejun
