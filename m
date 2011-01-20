Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1ATFSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 00:18:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54638 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1ATFSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 00:18:46 -0500
Date: Thu, 20 Jan 2011 05:18:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Steve French <smfrench@gmail.com>, Peter Teoh <htmldeveloper@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: CIFS related seg fault (v2.6.37)
Message-ID: <20110120051843.GO22723@ZenIV.linux.org.uk>
References: <AANLkTikp0=w7k+PsUCQVQwxnZMLsp3F7a3rEDQAas20G@mail.gmail.com>
 <4D37BDE4.1000104@suse.de>
 <AANLkTin7jRk6S2XWcRineCtazQb3rgYsBPakV513Ph9n@mail.gmail.com>
 <4D37C1AE.7040100@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D37C1AE.7040100@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 10:31:34AM +0530, Suresh Jayaraman wrote:

> Sorry it was not a VFS fix but a fix from Al Viro that fixed this
> problem. IIUC, the commit has made it to cifs-2.6.git but not upstream.
> 
> commit 1c929cfe6d8f2087a337a868fbf6c38d56bb4889
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sat Dec 18 11:43:51 2010 -0500
> 
>     switch cifs

It is in the mainline.  And there's no way anybody could've seen such
trace on .37 or earlier, since d_set_d_op() didn't exist before that.
