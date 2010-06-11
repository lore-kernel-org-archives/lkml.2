Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab0FKJqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 05:46:24 -0400
Received: from crca.org.au ([74.207.252.120]:50974 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759955Ab0FKJqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 05:46:23 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C1205DC.1080200@crca.org.au>
Date: Fri, 11 Jun 2010 19:46:04 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [linux-pm] [PATCH 1/9] PM / Hibernate: swap,	switch to hibernate_io_handle
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

(Sorry Jiri - unintentionally originally replied only to you).

On 02/06/10 18:52, Jiri Slaby wrote:
 > Hi,
 >
 > I addressed the comments I got on the previous RFC. I left the handles
 > in place, the functions in hibernate_io_ops now works on them. Further
 > I got rid of the memory barriers and minimized global variables as much
 > as possible. Comments welcome.

I would like to hear the arguments for using these handles. I understand 
there may have been some previous discussion, but am unable to find it.

It seems far more sensible to me to not pass around a handle that 
virtually nothing actually uses, and instead store and utilise the state 
in the place where it is actually useful. If we had more than one struct 
hibernate_io_handle in use at a time, I could understand going this way. 
As it stands, however...

Regards,

Nigel
