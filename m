Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab2LIRSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 12:18:46 -0500
Received: from plane.gmane.org ([80.91.229.3]:36962 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab2LIRSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 12:18:45 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tristan Wibberley <tristan.wibberley@gmail.com>
Subject: Re: New system call wanted: fdreopen
Date: Sun, 9 Dec 2012 17:18:23 +0000 (UTC)
Message-ID: <ka2h4v$ra3$2@ger.gmane.org>
References: <ka2982$ra3$1@ger.gmane.org> <20121209162746.GA23890@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 87.112.131.179
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
	git://git.gnome.org/pan2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Dec 2012 11:27:46 -0500, Theodore Ts'o wrote:

> On Sun, Dec 09, 2012 at 03:03:30PM +0000, Tristan Wibberley wrote:
>> 
>> - /proc/self/fd/* does not solve this problem because the file might no

...

> Actually, /proc/self/fd/* _will_ work.  When you do a ls -l, it looks
> like a symlink, but the files in /proc/self/fd (and /proc/<pid>/fd more
> generally) are magic.  If you open files in /proc/<pid>/fd/*, it will do
> what you want.

Oh! Cool! By reading how to solve this class of problem with google 
search results I couldn't find any indication that /proc/pid/fd/* worked 
differently than a symlink.

Thanks for your quick reply.

-- 
Tristan

