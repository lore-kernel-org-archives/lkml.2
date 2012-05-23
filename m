Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab2EWPdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:33:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62288 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933713Ab2EWPdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:33:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120523151538.GJ14943@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
	<20120522211706.GH14339@google.com>
	<20120523151538.GJ14943@redhat.com>
Date: Wed, 23 May 2012 11:33:30 -0400
Message-ID: <CAH+dOx+DhSweOvZZv3dVcedeBBZZ0=zondmKTDzMVXPdWZr=JA@mail.gmail.com>
Subject: Re: [dm-devel] [Bcache v13 09/16] Bcache: generic utility code
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tejun@google.com>, linux-bcache@vger.kernel.org, agk@redhat.com,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 11:15 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Another thing is that keep variable names consistent. Last time I looked,
> same name "c" was being used to represent cached_dev or cache_set or
> something else too. If we keep variable name same to represent same
> data structure, it becomes easier to read the code. I was totally lost
> and always had to go back to figure out what "c" is representing, what
> "d" is representing etc.

Yeah, those examples are both cases where the struct was split -
struct cache was broken into struct cache and cache_set, struct
bcache_device was split off from cached_dev.

I've been fixing things as I go along, but probably I should just do
them all at once and be done with it, damn the code churn.
