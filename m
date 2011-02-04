Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1BDUNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:13:15 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:20470 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752173Ab1BDUNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:13:14 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: M181pY8VM1lDSggS.OXLtVGFzdztrmnUwGoihyJKL0aR2ko
 xIndfsb8wPLvfZ7VZ61nlzE4Xj2Xn1Wiqbu96O_wMyWLOv29BvIKfgllSNTw
 Hygi53vXyDFYuIaJKGpxv1zgSv49kAJSaEQ5fYacP6f_VMdc0CuJtHuvvoZl
 NURNdZlFqgoXflm57UANyBFd2fKmfSxzNo_YgtmCkpL0aEpbf7iAeRqv9sVM
 e53l0LLp7N2SdX3AtuR07qa7gYWFu9cPB4LvcS5H.Ax8sxjo-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 4 Feb 2011 14:13:12 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: Thread Affinity structure
In-Reply-To: <AANLkTimZTbWt19hg8XWxL+Q5TBFY0P8wF-TfFDLYjBCw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1102041412170.6690@router.home>
References: <AANLkTinbnrAMMKVZSBQChtZjUyw6Yk1otp8xmqJNvWm3@mail.gmail.com> <alpine.DEB.2.00.1102041326330.4611@router.home> <AANLkTimZTbWt19hg8XWxL+Q5TBFY0P8wF-TfFDLYjBCw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-1526287847-1296850393=:6690"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-1526287847-1296850393=:6690
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 4 Feb 2011, Sri Ram Vemulpali wrote:

> Hi Christoph,
>
>   Thanks for response. Can you please explain in little bit elaborate
> what do you mean
>
>  "The value returned =A0from a call to gettid(2) can be passed in the arg=
ument
>  pid. =A0Specifying pid as 0 will set the attribute for the calling threa=
d,
>  and passing the value returned from a call to getpid(2) will set the
>  attribute for the main thread of the thread group."
>
> To whom I should pass the id. I did not understood.

The passage was from the man page that you get by typing

man sched_setaffinity


You pass the id as a parameter to sched_setaffinity.

---1463811839-1526287847-1296850393=:6690--
