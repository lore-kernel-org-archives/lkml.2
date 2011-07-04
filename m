Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1GDDsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 23:48:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48600 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab1GDDsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 23:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <CA367A4F.1479D%dmitry.fink@palm.com>
References: <CAEwNFnAYAWy4tabCuzGUwXjLpZVbxhKMmPXnhmCuH5pckOXBRw@mail.gmail.com>
	<CA367A4F.1479D%dmitry.fink@palm.com>
Date: Mon, 4 Jul 2011 12:48:48 +0900
Message-ID: <CAEwNFnD5=DEX1_iTZ4=7-1j4_r4hxMOsCb=NBT6EHYGFvH7fig@mail.gmail.com>
Subject: Re: [PATCH 1/1] mmap: Don't count shmem pages as free in __vm_enough_memory
From: Minchan Kim <minchan.kim@gmail.com>
To: "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>
Cc: Dmitry Fink <finikk@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 4, 2011 at 12:10 PM, Dmitry Fink (Palm GBU)
<Dmitry.Fink@palm.com> wrote:
> If I understand the logic correctly, even systems with swap set to
> OVERCOMMIT_GUESS are equally affected,
> what we are trying to do here is count the amount of immediately available
> and
> "potentially" available space both in memory and in swap. shmem is not
> immediately
> available, but it is not potentially available either, even if we swap it
> out, it will
> just be relocated from memory into swap, total amount of immediate and
> potentially
> available memory is not going to be affected, so we shouldn't count it as
> available
> in the first place.

Agree. I think this is good one rather than old description.

-- 
Kind regards,
Minchan Kim
