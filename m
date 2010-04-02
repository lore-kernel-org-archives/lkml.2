Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0DBUPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:15:31 -0400
Received: from cirrus.hsolutions.ch ([213.5.155.211]:47532 "EHLO
	cirrus.hsolutions.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab0DBUPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:15:25 -0400
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Apr 2010 16:15:25 EDT
Message-ID: <4BB64EA4.40601@hsolutions.ch>
Date: Fri, 02 Apr 2010 22:08:04 +0200
From: Denis BUCHER <dbucherml@hsolutions.ch>
Organization: Horus Digital Solutions =?ISO-8859-1?Q?S=E0rl?=
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr-CH; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: kernel crashing with reare bug
References: <4BB64E5E.5050706@hsolutions.ch>
In-Reply-To: <4BB64E5E.5050706@hsolutions.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02.04.2010 22:06, Denis BUCHER a écrit :
> Dear all,
>
> I am sorry to post a personal problem, but I saw it nowhere on the web,
> therefore I think it's really a special problem. Our server is regularly
> crashing (every 2 months), always too fast to get any log.
>
> But today we got this :
>
> kernel: alloc_fd: slot 0 not NULL!
>
> I would be very interested to know what it means ?!
>
> (Not being subscribed to the list, please answer personally...)
>
> Have a nice day, and thanks in advance for any hint :-)
>
> Denis


Maybe I should add :

kernel: Linux version 2.6.27.25-78.2.56.fc9.i686 (mockbuild@) (gcc 
version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #1 SMP Thu Jun 18 
12:47:50 EDT 2009
