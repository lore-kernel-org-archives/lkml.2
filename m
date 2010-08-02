Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0HBSo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:44:58 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:39304 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab0HBSoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:44:55 -0400
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Kees Cook <kees.cook@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
In-Reply-To: <20100802165936.GV3948@outflux.net>
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
	 <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
	 <20100802122421.GA12130@infradead.org>  <20100802165936.GV3948@outflux.net>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 02 Aug 2010 14:34:21 -0400
Message-Id: <1280774061.2673.115.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 09:59 -0700, Kees Cook wrote:
[...snip]
> 
> I've seen two so far. Both are addressed with a one line fix. And I would
> stress that no other existing subsystem in the kernel can provide the same
> level of control that my ptrace exception logic provides. SELinux cannot do
> this.
> 

Would you mind explaining to me what you believe this patch can do that
SELinux can't? Based on what I read in the kconfig entry for the feature
and the subsequent exception patch I'm not seeing anything here that
SELinux can't do. If there is something we are missing I'd like to
understand it so we can make the decision on whether or not our ptrace
access control checks need to be modified.

Dave


