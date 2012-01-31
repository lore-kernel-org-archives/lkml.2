Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2AaBaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:30:20 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42901 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab2AaBaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:30:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sysfs regression: wrong link counts
References: <4F27120A.4040106@suse.cz>
Date: Mon, 30 Jan 2012 17:32:58 -0800
In-Reply-To: <4F27120A.4040106@suse.cz> (Jiri Slaby's message of "Mon, 30 Jan
	2012 22:56:26 +0100")
Message-ID: <m1ipjshd11.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+RmA9irA4DC1Mo52cuKuwtOuJh2D3HmAY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> 1) network systemd rule doesn't start network

What silly thing is the network systemd rule doing?

Eric
