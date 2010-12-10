Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0LJRmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:42:43 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35306 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab0LJRml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fu5rkmlzPteybaVx/Vu14cp9gdsT5K9KoW0onVCKk2c5zxiKoGXX1MMlLmybUHDIjc
         Th35YndjMP+p3FkX3Xv1WG6mAVjCW/qhv3O6aQqCvvh6+kdFVXG8BMKsdr8HS0bCvCKj
         pTWFYuMLxvY+4SQvvvkX9gUyNDUW4AumLt5qc=
MIME-Version: 1.0
In-Reply-To: <4D026634.4000602@euromail.se>
References: <1292001842-5000-1-git-send-email-rydberg@euromail.se>
	<20101210173611.GA1630@core.coreip.homeip.net>
	<4D026634.4000602@euromail.se>
Date: Fri, 10 Dec 2010 09:42:40 -0800
Message-ID: <AANLkTimnJpmRJCFhOvZndTmL3r21KEdqXr2Bd9ZT3kUb@mail.gmail.com>
Subject: Re: [PATCH v2] input: mt: Interface and MT_TOOL documentation updates
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 9:41 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On 12/10/2010 06:36 PM, Dmitry Torokhov wrote:
>
>> On Fri, Dec 10, 2010 at 06:24:02PM +0100, Henrik Rydberg wrote:
>>> +#define MT_TOOL_ENVELOPE    2       /* rectangle corner - legacy use only */
>>
>> Legacy to me implies we can upgrade, but this is hardware limitation.
>> Can we say "rectangle corner - used by older hardware"?
>>
> How about "- older hw only", to stay within a single line?

Why do we suggest it will only be used by older hardware?

Ping
