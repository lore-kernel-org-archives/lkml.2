Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab2EHVD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:03:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36175 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2EHVD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:03:26 -0400
MIME-Version: 1.0
Date: Tue, 8 May 2012 16:03:25 -0500
Message-ID: <CAAZUjxBp7f_Tt3bXSOcac6RmeT23npELYO52P_2LdMN-MdH=7g@mail.gmail.com>
Subject: Work queues and cpu isolation
From: wilson self <wself00@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have done some reading on the subject of work queues and CPU
isolation, and specifically I've read a number of posts from Max K.
dating back to 2008 on the subject of CPU isolation.  However, I have
not seen much in the way of discussion on the subject in more recent
times, specifically in the 3.x kernels; where it appears there are
some significant differences in the structure of workqueue in general.

Is there anyone currently doing work on additional isolation of CPUs
from work queues? I have some requirement to further isolate cores on
a machine from these queues and am hoping someone here could point me
in the right direction.

Thanks.
wilson
