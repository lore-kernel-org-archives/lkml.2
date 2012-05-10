Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667Ab2EJVxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:53:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65377 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761611Ab2EJVxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120510215208.GC2613@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<ba8ce9fcca87f192ff5f5d3a436eb8f4d0bcb006.1336619038.git.koverstreet@google.com>
	<20120510213217.GN23768@redhat.com>
	<CAH+dOxL7QwcyUm46cK-pF1qK+kHYC=67iAaQDDwUF2ssJwergA@mail.gmail.com>
	<20120510215208.GC2613@redhat.com>
Date: Thu, 10 May 2012 14:53:03 -0700
Message-ID: <CAH+dOx+8jmSQSF2PqPb6aq3c3NsyyOOvycujbANNm6V6qBbd_Q@mail.gmail.com>
Subject: Re: [dm-devel] [Bcache v13 02/16] Bio pool freeing
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 2:52 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> ok, probably we could explain it more in changelog or push this in same
> patch where you introduce bio splitting so that bio shares bvec with other
> bio. That way it is easier to understand.

Yeah, agreed.
