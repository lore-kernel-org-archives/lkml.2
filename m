Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab0GHSxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 14:53:33 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63373 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab0GHSxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 14:53:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TbRAuP5ABuDu5TwDb/0LVJqLcgq02JuDB9oeMew15mplD+mp8ZwoJPfCD6CK2ERZ3X
         /neZedBWnJMS4F8lspVwFJ6JowN0HaaOK+8OnRmVkdNT1v9xNJG0/uIuXx16l31tVaPP
         IFMsUdVbOd7zJXBB6x68z9906qdOeLZgSbWFs=
Message-ID: <4C361ED1.60003@gmail.com>
Date: Thu, 08 Jul 2010 11:54:09 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: "Sergey V." <sftp.mtuci@gmail.com>, akpm@linux-foundation.org,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jillsmitt@linuxcenter.kz
Subject: Re: [PATCH v2]ipmi:ipmi_si_intf.c Fix warning: variable 'addr_space'
 set but not used
References: <1278436544-6091-1-git-send-email-justinmattock@gmail.com> <201007062205.30616.sftp.mtuci@gmail.com> <4C354EA7.1010802@gmail.com> <4C3618E3.5060307@acm.org>
In-Reply-To: <4C3618E3.5060307@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 11:28 AM, Corey Minyard wrote:
> On 07/07/2010 11:05 PM, Justin P. Mattock wrote:
>> what ever came about with this?
>>
>> Justin P. Mattock
> Well, Sergey sent a patch, but I don't think it was quite in a form that
> can be taken. Do you want to resend per the standard rules?
>
> -corey
>


yeah let me resend it..

Justin P. Mattock
