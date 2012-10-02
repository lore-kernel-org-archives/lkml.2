Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2JBF5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 01:57:14 -0400
Received: from 1wt.eu ([62.212.114.60]:35807 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab2JBF5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 01:57:12 -0400
Date: Tue, 2 Oct 2012 07:57:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [ 026/180] eCryptfs: Improve statfs reporting
Message-ID: <20121002055710.GB30406@1wt.eu>
References: <6a854f579a99b4fe2efaca1057e8ae22@local> <20121001225158.719221314@1wt.eu> <20121002054655.GA17360@boyd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002054655.GA17360@boyd>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 10:46:56PM -0700, Tyler Hicks wrote:
> On 2012-10-02 00:52:23, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> Hi - Please drop this patch. It incorrectly calculates f_namelen and I
> haven't had a chance to fix it yet. When I get a fix ready, I'll forward
> the corrected patch to stable@v.k.o. Thanks!

Done, thanks Tyler !

Willy

