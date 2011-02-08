Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1BHSOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:14:16 -0500
Received: from smtp-out.google.com ([74.125.121.67]:56179 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab1BHSOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 13:14:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LXuNziF4tSfvO5ieMDH71GXQbCk2cjtXOspuCeJSw6rwT1yEmuM+VWYJ4nWCN72/6f
         i5jHaEzz+T2OrnHv1qYA==
From: Venkatesh Pallipadi <venki@google.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@gmail.com>
Subject: Misc sd_idle related fixes
Date: Tue,  8 Feb 2011 10:13:36 -0800
Message-Id: <1297188819-19999-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <AANLkTikmWfLv3iMNUky7TRvQtUknLckftiQ4-Br614Rm@mail.gmail.com>
References: <AANLkTikmWfLv3iMNUky7TRvQtUknLckftiQ4-Br614Rm@mail.gmail.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the 3 sd_idle related changes I tested with, for reference. Among
the three, the third patch is the one that helps us in reducing idle cycles
with one of our workloads and thus improves the latency response.

Thanks,
Venki

