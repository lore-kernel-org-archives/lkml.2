Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2JEAoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 20:44:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41525 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2JEAoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 20:44:05 -0400
Date: Fri, 5 Oct 2012 01:43:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: keescook@chromium.org, levinsasha928@gmail.com, davej@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: prevent use after free in auditing when symlink
 following was denied
Message-ID: <20121005004359.GM23473@ZenIV.linux.org.uk>
References: <1349395000-12050-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349395000-12050-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 07:56:40PM -0400, Sasha Levin wrote:
> Commit "fs: add link restriction audit reporting" has added auditing of failed
> attempts to follow symlinks. Unfortunately, the auditing was being done after
> the struct path structure was released earlier.

Applied, and it's -stable fodder as well.
