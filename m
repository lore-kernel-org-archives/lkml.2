Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab2JBVUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:20:47 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:31366 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab2JBVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:20:46 -0400
Message-ID: <1349212844.3141.52.camel@lorien2>
Subject: Re: kernel NULL pointer dereference at rb_erase+0x1a3/0x370
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 02 Oct 2012 15:20:44 -0600
In-Reply-To: <20121002211007.GB15277@thunk.org>
References: <1349200709.3141.30.camel@lorien2>
	 <alpine.LSU.2.00.1210021317030.1700@eggly.anvils>
	 <20121002211007.GB15277@thunk.org>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 17:10 -0400, Theodore Ts'o wrote:
> The patch series in question has already been dropped, since there
> were some other problems found and we decided it wasn't ready for this
> merge window.
> 
> If you look at the latest linux-next branch, you'll see that those
> patches are gone, so it should be good once you upgrade to the latest
> linux-next.
> 
> 						- Ted

Great thanks.

-- Shuah

