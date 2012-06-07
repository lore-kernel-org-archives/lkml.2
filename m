Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2FGUps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:45:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56024 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab2FGUpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:45:47 -0400
Date: Thu, 7 Jun 2012 22:45:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: perf user tool precise attribute broken in 3.5rc1+
Message-ID: <20120607204546.GR27374@one.firstfloor.org>
References: <20120607202355.GQ27374@one.firstfloor.org> <CABPqkBSoCO4nSm==THVzVVu_cn=B5s4TZ_YpPxV73EGMNMgbrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSoCO4nSm==THVzVVu_cn=B5s4TZ_YpPxV73EGMNMgbrg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:25:47PM +0200, Stephane Eranian wrote:
> What CPU model?

I see it on Sandy Bridge and others. But the perf tool shouldn't know anything
about that anyways?  The kernel driver is ok

-Andi
