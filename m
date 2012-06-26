Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab2FZPXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:23:44 -0400
Received: from fieldses.org ([174.143.236.118]:58335 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757875Ab2FZPXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:23:43 -0400
Date: Tue, 26 Jun 2012 11:23:37 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Filipe Brandenburger <filbranden@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] locks: prevent side-effects of
 locks_release_private before file_lock is initialized
Message-ID: <20120626152336.GD14279@fieldses.org>
References: <1339815965-1171-1-git-send-email-filbranden@gmail.com>
 <1339815965-1171-2-git-send-email-filbranden@gmail.com>
 <20120618200131.GA12351@fieldses.org>
 <CABe66sW0k4N_7vMduOZMRak-U4A+6E7i+fiGwKEVBazJ1npBeg@mail.gmail.com>
 <20120626002908.GA14279@fieldses.org>
 <CABe66sV=coC3=-CU1uDrCfN7aucKg59emTZZS=kL41OwYyrNBw@mail.gmail.com>
 <CABe66sXc6tD83D=w_=YeNBo-5A7Q_KPTCq1-Dfnk9JCNw0i5ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABe66sXc6tD83D=w_=YeNBo-5A7Q_KPTCq1-Dfnk9JCNw0i5ug@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 10:10:35PM -0400, Filipe Brandenburger wrote:
> Just to let you know that I just tested the patch below on top of
> 3.5.0-rc4 and it works fine...
> 
> Do you like the idea of this second patch or do you prefer the
> __locks_free_lock() one?

Like I said:

> Let's just go with your first patch and free the thing by hand (but
> add a comment explaining why).
> 
> Then come back and figure out how to make the interface clearer once
> we've got the bug fixed.

--b.
