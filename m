Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab1KKEMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 23:12:23 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:52056 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab1KKEMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 23:12:22 -0500
Date: Fri, 11 Nov 2011 04:13:16 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: oleg@redhat.com, richard@nod.at, akpm@linux-foundation.org,
        ebiederm@xmission.com, dhowells@redhat.com, eparis@redhat.com,
        matthltc@us.ibm.com
Subject: Re: user namespaces: fix some uid/privilege leaks
Message-ID: <20111111041316.GA21010@hallyn.com>
References: <1320445482-8459-1-git-send-email-serge@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320445482-8459-1-git-send-email-serge@hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For what it's worth, and for anyone interested in taking a look, a
tree with feedback addressed is at

http://kernel.ubuntu.com/git?p=serge/linux-2.6.git;a=shortlog;h=refs/heads/userns.9

I'll re-test with and without userns next week, then resend.

thanks,
-serge
