Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab2F2TN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 15:13:59 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:58293 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab2F2TN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 15:13:58 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=hGT+JcDHQ8MMxxazPZmibYtb0Z3UtZWSQd5bZEc3WLmuJ12Ku5r8vU+M0P1i
	NkCex40YmPdNQnv1gFKlg6/WjP+o/Suz/wzDfyjlOUgb0ebeBDKjOoLup
	FQnsT42iIc4BEax1BL77C4LEkB9M1AaqNoqdtHLqYtbja7dWIi1sUM=;
X-Spam-Processed: mail.digidescorp.com, Fri, 29 Jun 2012 14:13:57 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=152756e0c6=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1340997235.9826.7.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH] fat: Refactor shortname parsing
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 29 Jun 2012 14:13:55 -0500
In-Reply-To: <87r4syrl4y.fsf@devron.myhome.or.jp>
References: <1340993528-12111-1-git-send-email-steve@digidescorp.com>
	 <87r4syrl4y.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-30 at 04:08 +0900, OGAWA Hirofumi wrote: 
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> > Nearly identical shortname parsing is performed in fat_search_long()
> > and __fat_readdir(). Extract this code into a function that may be
> > called by both.
> 
> What is the difference, and why changes was needed?

The only difference I could see was in the "dot_hidden" functionality.  
fat_search_long() never does it; __fat_readdir() does it only when the
'dotsOK' option is active.

The changes are not 'needed'; they are purely to simplify future
maintenance of the code.

Regards,
Steve


