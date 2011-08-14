Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750955Ab1HNEBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 00:01:04 -0400
Received: from smtp.unlimitedmail.net ([94.127.184.244]:42116 "EHLO
	dcnode-02.unlimitedmail.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750702Ab1HNEBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 00:01:01 -0400
Message-Id: <201108140400.p7E40gBC023531@dcnode-02.unlimitedmail.net>
Date: Sun, 14 Aug 2011 09:30:40 +0530
From: "J. Bakshi" <j.bakshi@unlimitedmail.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: where is /sys/class/power_supply/ADP1 ?
In-Reply-To: <201107302328.55921.rjw@sisk.pl>
References: <201107301330.p6UDUrt8004286@dcnode-01.unlimitedmail.net>
	<201107302328.55921.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAgMAAAAqbBEUAAAADFBMVEW2UCaWJQ3jnnRrCARshP4hAAACQElEQVQokRWSzU4aYRiFDwhiJjGAimxqRlzhbGpDm24wjmhTQtIIOlMag6GXUP92Tj5obcaaJqRJidvBlDi8N1FpbUzcFGgNK0MvgZKZsmHydVw+OWd1zgOiaH+98Ejt/SGCaTDlmZMYdl+cEmjMKQydBL97kJFAYlfbVab5KHS5AONrnoenPhVHbU1A4yezEYup+1crGRhtfuv9kPZtLRcz8Mw4ykJ1UPJF72Qkg09SdHFFxkY/iZW1HxNSY/zLSbS1B9sKLW7TaU3yB55DHXnjL4n0m1BSRNOZoKo8IXqx1YVqZ6is+C0YwS7Gml4q5/mdRFEbSkig95xbZEaHCMpEJ5x3yPRzyCEqzcTm0lMUscEEE0gfm/64RwPbpJyTIlPbLnNoMoku1JxNAHyTzhzQO2fWXL5PKgOD9H+fPQW4lUqnJk0OqkYEWorETE0SBzrmwFP0lj7Gn1r6qgZ4z8/jM/GVm7Mcg5apH4db8d43PccBoY6oHGAdPRuBX2m8DrSn+Y1+GALLNtLskjWFQHaEXsvMFvsFgc5sD4oyZT39wjiJQwu5ljRbSheqQnHIEfGfV2n+oL7KeBetvrcumQc1lbsQWJVj2fkDk/dceCwqi6qn4y7gcLxhlnCY71DgyGG4yNuvKnyPfBtzNipdRy6r/YXI9Pc+dM7WocqIHGU7KDlsSQn7wsHfSS9MVti9Dau5jfYkuU9Y13Z45+havZRg6H/Xhgk+au7c61L6FVD3XVu44IpkPpxUtnrqkiXRf3v/EFxxaZnHAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SOLTECSIS-MailScanner-ID: p7E40gBC023531
X-SOLTECSIS-MailScanner-From: j.bakshi@unlimitedmail.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jul 2011 23:28:55 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Saturday, July 30, 2011, J. Bakshi wrote:
> > Hello kernel gurus,
> > 
> > This is my very first email to this list, so greetings to all of you.
> > 
> > I have compiled the latest 3.0 kernel. But I have not found the 
> > 
> > /sys/class/power_supply/ADP1 and sys/class/power_supply/BAT0 any more
> > 
> > are they still supported in 3.0 ?
> 
> What's there in your /sys/class/power_supply/ with 3.0?  I surely have
> those links on my test systems.
> 

Problem solved with the new version of laptop-mode-tools 1.58
This version is designed to work with kernel 3.0

THNX
