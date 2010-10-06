Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0JFER6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:17:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070Ab0JFER5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:17:57 -0400
Date: Tue, 5 Oct 2010 21:18:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/3] access_error API cleanup
Message-Id: <20101005211835.070a5096.akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=+0i13JF552P7dF_JD+S10Lt8=+KySHdtg-Uex@mail.gmail.com>
References: <1286265215-9025-1-git-send-email-walken@google.com>
	<1286265215-9025-4-git-send-email-walken@google.com>
	<4CABF4F3.7050002@zytor.com>
	<AANLkTi=+0i13JF552P7dF_JD+S10Lt8=+KySHdtg-Uex@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010 21:14:12 -0700 Michel Lespinasse <walken@google.com> wrote:

> I figure barring any surprises, the series is likely to merge from -mm
> tree to mainline in time for 2.6.37 ?

yep.
