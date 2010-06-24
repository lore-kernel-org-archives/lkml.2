Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab0FXO4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:56:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab0FXO4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:56:36 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       "ocfs2-devel\@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync performance when using CFQ
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<4C21D442.8080703@oracle.com> <4C22F316.3080009@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 24 Jun 2010 10:56:28 -0400
In-Reply-To: <4C22F316.3080009@oracle.com> (Tao Ma's message of "Thu, 24 Jun
	2010 13:54:30 +0800")
Message-ID: <x49r5jwh42r.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tao Ma <tao.ma@oracle.com> writes:

> Hi Jeff,
>
[...]
> I am sorry to say that the patch make jbd2 locked up when I tested
> fs_mark using ocfs2.
> I have attached the log from my netconsole server. After I reverted
> the patch [3/3], the box works again.

Thanks for the report, Tao, I'll try to reproduce it here and get back
to you.

Cheers,
Jeff
