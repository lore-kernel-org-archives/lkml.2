Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1GSJDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 05:03:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49620 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752360Ab1GSJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 05:03:37 -0400
Date: Tue, 19 Jul 2011 10:06:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Clark, Joel" <joel.clark@intel.com>
Subject: Re: serial/pch_uart: AT command behavior
Message-ID: <20110719100613.21b9eb32@lxorguk.ukuu.org.uk>
In-Reply-To: <4E2504FD.6090107@dsn.okisemi.com>
References: <1308736219-19975-1-git-send-email-alexander.stein@systec-electronic.com>
	<4E02857C.1010304@dsn.okisemi.com>
	<4E2504FD.6090107@dsn.okisemi.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011 13:15:57 +0900
Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com> wrote:

> Hi,
> 
> I have a question for UART driver AT command behavior.
> When installing pch_uart, AT command "AT+GCAP^M" are sent for 4 times.
> This command is sent first install only.
> (After the above, removing pch_uart and installing pch_uart again,
> this command is not sent.)
> 
> Let me know the behavior is normal or not ?

As your distribution, it isn't the kernel.
