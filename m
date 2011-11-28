Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1K1HjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:39:05 -0500
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:45676 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750821Ab1K1HjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:39:02 -0500
MIME-Version: 1.0
In-Reply-To: <1322371662-26166-17-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-17-git-send-email-amwang@redhat.com>
From: Roland Dreier <roland@kernel.org>
Date: Sun, 27 Nov 2011 23:38:38 -0800
X-Google-Sender-Auth: exgE3DIDchDWAOBhoecauq1tCB8
Message-ID: <CAL1RGDXkh4xJJNO+7fkDXJ4f7LgwvbrHKTueiozUkiK0dkRBZA@mail.gmail.com>
Subject: Re: [PATCH 16/62] infiniband: remove the second argument of k[un]map_atomic()
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These look fine, given the second argument is unused.  So

Acked-by: Roland Dreier <roland@purestorage.com>

... or is there some point when the <linux/highmem.h> part is
going in and where it makes sense for me to apply this through
my tree?

 - R.
