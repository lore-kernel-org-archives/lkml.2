Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab2ILLeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:34:16 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47330 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2ILLeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:34:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120911155950.GA7431@redhat.com>
References: <1347380162-2359-1-git-send-email-vda.linux@googlemail.com> <20120911155950.GA7431@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 12 Sep 2012 13:33:53 +0200
Message-ID: <CAK1hOcP_3b3eHSdd1tPdtXJCmaHozfrbf7d0tEu=nboDvxhhwg@mail.gmail.com>
Subject: Re: [PATCH] fs: prevent double-free on an error path in core dumper
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        Roland McGrath <roland@hack.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 5:59 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> What do you think about the patch below?

Looks good.
You know that I like to *remove* code :)

-- 
vda
