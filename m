Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab2D1NpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 09:45:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44532 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab2D1NpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 09:45:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+1xoqf1mxbShV2OnLZCjacuyLAUvXwi_70ErOXb=hRTbx9Xcg@mail.gmail.com>
References: <1334903774.5922.35.camel@lappy> <CA+1xoqf1mxbShV2OnLZCjacuyLAUvXwi_70ErOXb=hRTbx9Xcg@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sat, 28 Apr 2012 15:44:44 +0200
Message-ID: <CA+1xoqeFY0oaj2uj3AkTLUwDbbcKjxPAVZR4gQBUKEVArQeLXg@mail.gmail.com>
Subject: Re: mm: divide by zero in percpu_pagelist_fraction_sysctl_handler()
To: Andrew Morton <akpm@linux-foundation.org>, mel@csn.ul.ie,
        cl@linux-foundation.org
Cc: linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, nevermind, I see the problem. I'll send a patch.

On Sat, Apr 28, 2012 at 3:21 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Ping? Still see it happening.
