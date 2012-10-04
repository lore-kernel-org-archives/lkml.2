Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206Ab2JDVss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:48:48 -0400
Received: from 1wt.eu ([62.212.114.60]:35921 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934150Ab2JDVsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:48:45 -0400
Date: Thu, 4 Oct 2012 23:48:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 092/180] udf: Avoid run away loop when partition table length is corrupted
Message-ID: <20121004214835.GP10245@1wt.eu>
References: <6a854f579a99b4fe2efaca1057e8ae22@local> <20121001225201.501807945@1wt.eu> <20121004212348.GG13292@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004212348.GG13292@decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 10:23:48PM +0100, Ben Hutchings wrote:
> On Tue, Oct 02, 2012 at 12:53:29AM +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jan Kara <jack@suse.cz>
> > 
> > commit adee11b2085bee90bd8f4f52123ffb07882d6256 upstream.
> > 
> > Check provided length of partition table so that (possibly maliciously)
> > corrupted partition table cannot cause accessing data beyond current buffer.
> [...]
> 
> This is not quite paranoid enough; please add commit
> 57b9655d01ef057a523e810d29c37ac09b80eead after this.

Queued, thanks!
Willy

