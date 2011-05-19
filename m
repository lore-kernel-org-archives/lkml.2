Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1ESFdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 01:33:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:53562 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab1ESFdB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 01:33:01 -0400
Subject: Re: powerpc: mpc85xx regression since 2.6.39-rc2, one cpu core lame
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1305755338.7481.8.camel@pasglop>
Date: Thu, 19 May 2011 00:32:48 -0500
Cc: Richard Cochran <richardcochran@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <369C774C-DF3B-4D8E-BABF-B1C9727AE96E@kernel.crashing.org>
References: <20110517162827.GA16918@riccoc20.at.omicron.at> <1305668416.2781.23.camel@pasglop> <20110518120320.GA3025@riccoc20.at.omicron.at> <1305755338.7481.8.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 18, 2011, at 4:48 PM, Benjamin Herrenschmidt wrote:

> 
>> (I get the feeling that I am the only one testing recent kernels with
>> the mpc85xx.)
>> 
>> Anyhow, I see that this commit was one of a series. For my own use,
>> can I simply revert this one commit independently?
> 
> For your own use sure :-) But I'd still like to get to the bottom of
> this !
> 
> Cheers,
> Ben.

Tested the 'merge' branch and it appears to fix the issues with secondary cores coming up.

- k