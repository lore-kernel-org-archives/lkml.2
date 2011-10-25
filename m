Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1JYQ5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:57:33 -0400
Received: from natasha.panasas.com ([67.152.220.90]:33454 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1JYQ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:57:31 -0400
Message-ID: <4EA6EA6F.1020602@panasas.com>
Date: Tue, 25 Oct 2011 09:57:19 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        git-commits-head <git-commits-head@vger.kernel.org>
Subject: Please re-enable the git-commits-head mailing list
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Since the brain stroke of vger.kernel.org we stopped getting any messages on
git-commits-head@vger.kernel.org It is important because of the mirroring delay of the gits which
can take 24 h in some places. And because it is a very convenient way to look for something or in
general keep track of what's going on.

Please re-enable it. It should be as simple as:
	git config --add hooks.mailinglist "git-commits-head@vger.kernel.org"

Or something, right?

Thanks
Boaz
