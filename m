Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0KVRep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:34:45 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59336 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0KVRel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:34:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uSeOd2xiVfLIA/vrwA9gBzNJDWEgXylVbVGc3jOgRXgjZICu/vAl2toMgnx/7igTyO
         ZcWeUk8PH24ey80tzzxn0m2TAvl4IetoHbEn2BHt8WULnhdM+VHY6YTSV6fRSnQVNehZ
         OCD7HihLuNzfx+zjiaBIuAPxca8b+Eg7cqbEs=
MIME-Version: 1.0
In-Reply-To: <093B58FD-0DA7-4E94-A70E-C926EC6D02F6@mit.edu>
References: <1290161589-5370-1-git-send-email-namhyung@gmail.com>
	<60024FF1-3903-49AD-9A68-B04C6D678A8E@mit.edu>
	<093B58FD-0DA7-4E94-A70E-C926EC6D02F6@mit.edu>
Date: Mon, 22 Nov 2010 09:34:40 -0800
Message-ID: <AANLkTimDZ26GPdTQaqF98=67qhOpRLuy+8Wpt=eXcV82@mail.gmail.com>
Subject: Re: [PATCH] ext3: Coding style fix in namei.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Namhyung Kim <namhyung@gmail.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 5:05 AM, Theodore Tso <tytso@mit.edu> wrote:
> Oooh, I forgot another downside which just came to mind:
>
> * Call of this code churn to fix whitespace all for the sake of keep some damned checkpatch.pl script happy also breaks "git blame" reports.
>
> -- Ted

Isn't that what git blame -w  (ignore whitespace) is for?

Harvey
