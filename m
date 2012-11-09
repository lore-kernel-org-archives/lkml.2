Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab2KIAmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 19:42:20 -0500
Received: from mail-gg0-f202.google.com ([209.85.161.202]:59326 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab2KIAmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 19:42:19 -0500
From: Sonny Rao <sonnyrao@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Mandeep Singh Baines <msb@chromium.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Olof Johansson <olofj@chromium.org>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>, Aaron Durbin <adurbin@chromium.org>
Subject: [PATCHv2] mm: Fix calculation of dirtyable memory
Date: Thu,  8 Nov 2012 16:42:03 -0800
Message-Id: <1352421724-5366-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20121108153756.cca505da.akpm@linux-foundation.org>
References: <20121108153756.cca505da.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add apkm's suggestion

