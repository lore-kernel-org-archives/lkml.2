Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2GTJg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:36:58 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:35156 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2GTJgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:36:55 -0400
Date: Fri, 20 Jul 2012 11:36:48 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: joe shmoe <joeshmoeypeter@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        daniel.kiper@oracle.com
Subject: Re: kdump/kexec vmcore size doubles each time
Message-ID: <20120720093648.GA3909@router-fw-old.local.net-space.pl>
References: <1342735724.60460.YahooMailNeo@web160604.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342735724.60460.YahooMailNeo@web160604.mail.bf1.yahoo.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 03:08:44PM -0700, joe shmoe wrote:
> Hi,
> I am trying to configure kexec/kdump on 2.6.35-14.
>
>
> $> kexec --version
> kexec-tools-testing 20080330 released 30th March 2007

[...]

It is very ancient version. Please use at least Ver. 2.0.3
(http://kernel.org/pub/linux/utils/kernel/kexec/) or current
development version (git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git).

Daniel
