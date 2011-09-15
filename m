Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934927Ab1IOU5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:57:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45579 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934775Ab1IOU5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:57:10 -0400
Date: Thu, 15 Sep 2011 22:57:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH 07/27] Initconst section fixes for POWERPC
Message-ID: <20110915205709.GB7761@one.firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org> <1316117394-21666-8-git-send-email-andi@firstfloor.org> <CA+5PVA66idjR6uLaJOJm81ZJrjRiYQVJMvKNttAS7B=4iUoqVQ@mail.gmail.com> <4E726489.6080606@linux.intel.com> <CA+5PVA52Q+9jBbF7fdjDgpkv9rAwPKgyH+34zMPxYXusn-LctQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA52Q+9jBbF7fdjDgpkv9rAwPKgyH+34zMPxYXusn-LctQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 04:56:04PM -0400, Josh Boyer wrote:
> On Thu, Sep 15, 2011 at 4:48 PM, Andi Kleen <ak@linux.intel.com> wrote:
> > On 9/15/2011 1:45 PM, Josh Boyer wrote:
> >>
> >> On Thu, Sep 15, 2011 at 4:09 PM, Andi Kleen<andi@firstfloor.org>  wrote:
> >>>
> >>> From: Andi Kleen<ak@linux.intel.com>
> >>>
> >> What's the problem again?
> >
> > It's wrong. For more details see 0/*
> 
> Do you have an example of the compiler/linker erroring out?

You currently need a special toolkit set up for this, it doesn't 
happen in normal builds. It's still wrong however.

-Andi
