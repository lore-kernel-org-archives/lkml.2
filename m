Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab1KAGc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 02:32:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35985 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1KAGcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 02:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110311554580.22237@chino.kir.corp.google.com>
References: <1319811801-1725-1-git-send-email-penberg@kernel.org>
	<1319811801-1725-6-git-send-email-penberg@kernel.org>
	<alpine.DEB.2.00.1110311554580.22237@chino.kir.corp.google.com>
Date: Tue, 1 Nov 2011 08:32:54 +0200
X-Google-Sender-Auth: 37xk2gmfHknckNIN1BJIRisk2WA
Message-ID: <CAOJsxLHWtN+88CErqbDDqT20saDyxLcdca8R2eV9nA9jvjUdGw@mail.gmail.com>
Subject: Re: [RFC/PATCH 6/7] x86, mm: Prepare zone_sizes_init() for unification
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Nov 1, 2011 at 12:56 AM, David Rientjes <rientjes@google.com> wrote:
> I'd just fold patch 7 into this, it doesn't make much sense to have add
> CONFIG_HIGHMEM code for 64-bit, for example, just to make the next patch
> simpler.

Actually, I don't agree.

Whenever I've done unification patches, I've always made sure the
patch that does the actual unification is just code shuffling. That
improves bisectability and makes reviewing easier.

                        Pekka
