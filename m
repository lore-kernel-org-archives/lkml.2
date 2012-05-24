Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441Ab2EXQiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:38:04 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:37444 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab2EXQiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:38:00 -0400
Message-ID: <4FBE63DC.8020101@xs4all.nl>
Date: Thu, 24 May 2012 18:37:48 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, hdegoede@redhat.com
Subject: Re: pwc driver bugs
References: <4FBE4DD5.50906@xs4all.nl> <20120524165638.0ade5a6f@pyramind.ukuu.org.uk>
In-Reply-To: <20120524165638.0ade5a6f@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-24 17:56, Alan Cox wrote:
> commit ceede9fa8939e40ad0ddb4ad1355f45c6f1d3478
> 
> looks rather relevant here.

The commit does not apply cleanly to 3.3.7.
What are the dependencies for this patch to apply, so I can try to test
this code?

Kind regards,
Udo

