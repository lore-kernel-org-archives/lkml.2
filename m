Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab2EVPlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:41:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61153 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759099Ab2EVPlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:41:05 -0400
Subject: Re: tcp timestamp issues with google servers
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87zk90s0em.fsf@tucsk.pomaz.szeredi.hu>
References: <87r4ujno34.fsf@tucsk.pomaz.szeredi.hu>
	 <1337278363.3403.39.camel@edumazet-glaptop>
	 <87zk90s0em.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 May 2012 17:40:59 +0200
Message-ID: <1337701259.3361.208.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 17:25 +0200, Miklos Szeredi wrote:

> So it appears.  The IP address is certainly registered to Google.

Good, but you could have a middlebox doing transparent proxying.

The SYNACK could be send by this box.



