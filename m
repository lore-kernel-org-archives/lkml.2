Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1ALXOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 18:14:15 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35440 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1ALXOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 18:14:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=esJMhLCeJEU3SM7hZ/CkM+XthxJj6m3lD3h8siUTXQ4JM/SOpUXp3HJ2B34tLOMVvU
         YGQzFKHsbIX0H19lEUm/SsnHbW9oIvGXVorkLs5GNZuwC7SoOvRXJ5UwERumkYLfFi75
         dTeCv9T3v5KKqPF7H6V9z0KsEoruQYbg7oGyE=
MIME-Version: 1.0
In-Reply-To: <1294845571-11529-1-git-send-email-emunson@mgebm.net>
References: <1294845571-11529-1-git-send-email-emunson@mgebm.net>
Date: Thu, 13 Jan 2011 08:14:12 +0900
Message-ID: <AANLkTimFGNxJzNMAJg-mWN-VOxonQ+odE9WBEEEsaw5O@mail.gmail.com>
Subject: Re: [PATCH] Rename struct task variables from p to tsk
From: Minchan Kim <minchan.kim@gmail.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, mel@csn.ul.ie,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 12:19 AM, Eric B Munson <emunson@mgebm.net> wrote:
> p is not a meaningful identifier, this patch replaces all instances
> in page_alloc.c of p when used as a struct task with the more useful
> tsk.
>

Yesterday, Andrew raise an eyebrow about that.
His simple lookup found below.

--

On Tue, 11 Jan 2011 13:03:22 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:
> On Tue, 11 Jan 2011, Andrew Morton wrote:
< snip >
> > Oh, and since when did we use `p' to identify task_structs?
>
> Tsk, tsk: we've been using `p' for task_structs for years and years!

Only bad people do that.  "p".  Really?

z:/usr/src/linux-2.6.37> grep -r " \*p;" . | wc -l
2329
z:/usr/src/linux-2.6.37> grep -r "task_struct \*p" . | wc -l
824

bah.

-- 

How about cleaning up everything in this chance?




-- 
Kind regards,
Minchan Kim
