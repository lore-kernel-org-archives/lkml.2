Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0GIDAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:00:34 -0400
Received: from smtp106.rog.mail.re2.yahoo.com ([68.142.225.204]:34838 "HELO
	smtp106.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755315Ab0GIDAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:00:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=FPhXPT2qVjacBwaP4Vz896lj8BbzR+Tl3jfe48NKXcuYE1KN9hH6pcMk7DD5djgonNzfXQIx9yQ6989eTDBbvs3LbeL9pBXElYw0BU0bxDhyUOAOe5rMQE32gAlYywlQCVz9hBOIGpYKflyhhweZqu1jbK05MfiUP9KTzgjz26Y=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: G6jrrawVM1ntz1OUj_C00TZMwiBIxomv6B0pEYaqgBgR9R6uS0C7NcociOHCjnwtYUNq2N7E9KkswxMUVmhaQBAI5JJLlKBE3_ZI5brGCD1suAOjUP3A674AyjaKPJYFbAFDLQNH9c9mQamLEwXr2IE3eGKUzwxnI2nMtFJ88ZhTtzLp1d0Z0jn7fzePh8gNLTx1jw_e5lT.3NWorMURlJ_8Y5C9I0CPeeubvSxBHoTxFj41ILnzxQz8o3D.riSHc6LB7aoQ0M0NqOlUxlgLy8haHLNJqMol0H70DICbg0SdCRRGOvLWRCwQL6YS6rhazSmk.Tz6Uye96cE7b20DdiJNy0vItsn7bccFyK.vRQU.fLoeByNdRDjcH64lmrTH63LfeDbGqRmjl2VP6cPKpe16CU5KuQZj7gOCC4maMhzdVl1aYDD_GUtLRR43xQ--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #16311] [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500 laptop
Date: Thu, 8 Jul 2010 23:00:51 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.90; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <TXb9XdQzJoD.A.YHB.IMmNMB@chimera>
In-Reply-To: <TXb9XdQzJoD.A.YHB.IMmNMB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007082300.51672.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 08, 2010 07:41:40 pm Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the
> tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16311
> Subject		: [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend Lenovo W500
> laptop Submitter	: Shawn Starr <shawn.starr@rogers.com>
> Date		: 2010-06-28 0:45 (11 days old)
> Message-ID	: <201006272045.17004.shawn.starr@rogers.com>
> References	: http://marc.info/?l=linux-kernel&m=127768633705286&w=2

Continues with July 7th, snapshot of 2.6.35-rc4. 

Some more info: I have USB in use while trying to suspend.  A USB Microsoft 
Mouse and a QuickCam Pro 9000 camera connected.

Thanks.
Shawn
