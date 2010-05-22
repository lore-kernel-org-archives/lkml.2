Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab0EVTm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 15:42:26 -0400
Received: from smtp104.rog.mail.re2.yahoo.com ([206.190.36.82]:36088 "HELO
	smtp104.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755756Ab0EVTmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 15:42:23 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 May 2010 15:42:23 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=OYOXEayl2jMSZx7EbBawQXiPN2aGmn+M97c4W26DDSNOFM+3iXgL0qNrji+T5WjDqFiQxaEo1GvviulIeG0wttCM31NqmugR0mgnTvDN+P0Q7AK2rSGYV5RhwWMj/R7JWzOMsQitu+CXLZlptlLYO6U4AoMn+XyA6f3xRKacEZk=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: 48eV.iIVM1m5T4gN8cqNjgq07R1aY1RrACxeIBCA4efBaspg59J9TYOkVb7PShv0LEwtQcjJA0a3qq.CShHg7E8C9UcvCYSXpcjkYSCClk92OpHtXfvuIYEarDYTfQ9mu1cMRyACJV5_8CiDXzogKiyB34guGGx0mmzXsm3.p7Uq_IjPWY9lUgN3qBpmokHocH3UeJUxh5wZVMcpLN9HM1bsa1kplVH7wDs50C7FRgTkNssAm2RM.lFw69qP0RgPVJklcVypG5TONXuxNNC.lXghBWVOloJuPcsl5JlKd6oqaxQymaCKBKoAeQs.0HWgvv1DpVK9Xi41mcHHkErQzcQWZz6XQirszUYbOYRWn4XQyRGlA2z4Cic1MUsEQ0CsyS_UQD82tnrpoQmKzDAuG6Gh8KQ-
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.34-git8][regression] massive polling problems with udevd and other processes
Date: Sat, 22 May 2010 15:35:38 -0400
User-Agent: KMail/1.13.3 (Linux/2.6.33.4-95.fc13.x86_64.debug; KDE/4.4.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005221535.38939.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just built today's snapshot from linus's tree and have problems with udev 
using 100% cpu and KDE processes also pegging cpus.

This is with Fedora 13 + snapshot kernel from git.

Anyone else noticing this?

Thanks,
Shawn.
