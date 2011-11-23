Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab1KWGYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:24:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50402 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab1KWGYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:24:05 -0500
MIME-Version: 1.0
In-Reply-To: <20111122221916.GD24283@suse.de>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
	<1321999366-23784-3-git-send-email-corentincj@iksaif.net>
	<20111122221916.GD24283@suse.de>
Date: Wed, 23 Nov 2011 07:24:03 +0100
Message-ID: <CAHR064j9MNvfikxfOud7_u3nemye5LbkFxF_SXaCgJmV5quxQA@mail.gmail.com>
Subject: Re: [PATCH 02/15] samsung-laptop: move code into init/exit functions
From: Corentin Chary <corentin.chary@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:19 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Nov 22, 2011 at 11:02:33PM +0100, Corentin Chary wrote:
>> Create _init()/_exit() function for each subsystem, remove
>> the local struct samsung_laptop * and only keep a
>> struct platform_device * that can only be used in samsung_init()
>> and samsung_exit().
>>
>> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
>
> It seems a little gratitous, but hey, if you want to maintain this
> driver, I have no objection to you rewriting the thing :)
>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Well, doing that seems to help with error paths, and make it easy
separate functionalities, in my opinion.

-- 
Corentin Chary
http://xf.iksaif.net
