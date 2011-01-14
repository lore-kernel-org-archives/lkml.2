Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab1ANJrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:47:53 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52870 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1ANJrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:47:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=uBLUQ8vVlyM9TaoC/jdIXT7syNt/Wj3203sbDZsL4ollnGo6LP3sRBaECcOHyOZJAi
         6o7pj0U7ON0quOr/kGUchCahCP54d6Fjo4xKPkQ/Z3NbfjC6HUkX3iwjrPQ8R3sElXjq
         HX5RSOa4sNWXDYw96lTM89Ul4qtaVtkGOXHFA=
Date: Fri, 14 Jan 2011 17:47:38 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jianbin Kang <kjbmail@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: add global tags generation.
Message-ID: <20110114094738.GC10219@cr0.nay.redhat.com>
References: <AANLkTimsPj4seDW9ffDQ+uydZcRk_T6BsP7x0dr0Qi++@mail.gmail.com>
 <20110114093319.GA10219@cr0.nay.redhat.com>
 <AANLkTinp4x7i+771CQdCJQmEJthBjow3ZR305ie-iYHb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinp4x7i+771CQdCJQmEJthBjow3ZR305ie-iYHb@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 05:43:51PM +0800, Jianbin Kang wrote:
>2011/1/14 Américo Wang <xiyou.wangcong@gmail.com>:
>> On Fri, Jan 14, 2011 at 03:13:01PM +0800, Jianbin Kang wrote:
>>>gnu global (http://www.gnu.org/software/global/) is a source code tagging system
>>>It is really cheap to support it in kbuild system.
>>>
>>
>> Looks pretty good,
>>
>> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>>
>> But... 1) you missed your Signed-off-by; 2) you should Cc linux-kbuild
>> rather than trivial.
>er, where should signed-off-by be put? At the bottom of the mail or
>the bottom of the patch?

Usually, it is at the bottom of the patch description,
see Documentation/SubmittingPatches.
