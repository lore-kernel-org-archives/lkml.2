Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab2CLRbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:31:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52679 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab2CLRbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:31:50 -0400
Date: Mon, 12 Mar 2012 10:31:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Prashanth K Nageshappa <prashanth@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [ 29/68] kprobes: return proper error code from register_kprobe()
Message-ID: <20120312173144.GA7087@kroah.com>
References: <20120309194409.GA2069@kroah.com>
 <20120309190217.319548473@linuxfoundation.org>
 <20120312045749.GA15945@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312045749.GA15945@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 11:57:49PM -0500, Jonathan Nieder wrote:
> Hi,
> 
> Greg KH wrote:
> 
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
> >
> > commit f986a499ef6f317d906e6f6f281be966e1237a10 upstream.
> 
> Looks good for 3.2.y.
> 
> This is a pointless no-op in 3.0.y, since it doesn't include commit
> bc81d48d13d8 (kprobes: Return -ENOENT if probe point doesn't exist,
> 2011-06-29).

Thanks for letting me know, I've dropped it from the 3.0 tree now.

greg k-h
