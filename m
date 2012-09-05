Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab2IEVLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:11:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48879 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2IEVLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:11:46 -0400
Date: Wed, 5 Sep 2012 14:09:12 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [REVIEW][PATCH 10/15] userns: Convert debugfs to use kuid/kgid
 where appropriate.
Message-ID: <20120905210912.GE27262@kroah.com>
References: <87lih2h6i4.fsf@xmission.com>
 <871uiufrj6.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871uiufrj6.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 05:03:41PM -0700, Eric W. Biederman wrote:
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
