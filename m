Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2D2QoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 12:44:04 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:3790 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122Ab2D2QoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 12:44:02 -0400
X-IronPort-AV: E=Sophos;i="4.75,500,1330902000"; 
   d="vcf'?scan'208";a="156089319"
Message-ID: <4F9D6FD0.3040904@loria.fr>
Date: Sun, 29 Apr 2012 18:44:00 +0200
From: Jens Gustedt <Jens.Gustedt@loria.fr>
Reply-To: Jens.Gustedt@loria.fr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: BUG in 3.3.4
References: <iTWyS-35l-7@gated-at.bofh.it> <4F9D2A2B.9090501@loria.fr> <20120429155524.GA29152@ericsson.com> <20120429160400.GA29231@ericsson.com>
In-Reply-To: <20120429160400.GA29231@ericsson.com>
X-Enigmail-Version: 1.4
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAACRQTFRF
 ERslNjAsLTE9Ok9wUk9TaUs8iWhSrYZkj42Rz6aD3sGZ/P/7B+vw4wAAAAlwSFlzAAALEwAACxMB
 AJqcGAAAAAd0SU1FB9gGGQk7HLeKUa8AAAIoSURBVDjLhdOxbtswEABQyhmz8BjJ7WjRTVHAk2O3
 S5baUNNm1EB59iAJ6m4R2osgRdfWAv0H0Za6QGPo53onOxYtIOhNgh7IuyOPrH4h2H/hvp5Q/OjC
 djIN5lKKYRcmUxWHACCvOzCNojj0FAh5CpObJM1jpXDRyIZtX+uiREG4sGGcGgydUxpuwdYrCEqd
 KwB23cKfV6aJkoCftzDOzKaqUPL4FN4XL8AnY6oGNGbnZy3c7HBB9YDZk1DwXgtvaKeHpixcsS+r
 gbe4S2UOAGx0hEv8uWlyIPjs3NrqsJfOlzCwwG/K3VD2JW510TbYlgvgOy1c7fsrMYNAGB7hd7ah
 o6KS8A5lrz3d27UKVRpDA34L9S39W6z6OvYQhhasFajsV5TjREhpwU6nOi7WfY15pH9tgdFJataq
 ILBusN6VVNVapQjChtps6HDDiA7rBL5j1wgeTdYJ/DU5TlAISqkOaJUVJQJ0IY+aEwSI4cwqt35a
 RVqv8L+3FGwwsqY9iULsWxHwAd36M3xI869VsQQvBDZgKM/wlOrCJKoBisnxDX7Gh4DpPdgDO77B
 S61x3DzVge3YzbBeFYUHcA4g4V1EE5fgUDscwd1frT8TAWSmLGnae5Ix7u/nCjv7CQucN/xgcoAb
 AcF4Br77zVskCY4bOIHPOCe4ghmI4M5bNOPDe3OB8JHV2xmG/+VOpVgugjsXDnNxxaM7c93g9T0B
 dgHBXPQ4OP8ApiUfmpUgHuIAAAAASUVORK5CYII=
Content-Type: multipart/mixed;
 boundary="------------070202030805020201070109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070202030805020201070109
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Am 04/29/2012 06:04 PM, schrieb Guenter Roeck:
> On Sun, Apr 29, 2012 at 08:55:24AM -0700, Guenter Roeck wrote:
>> On Sun, Apr 29, 2012 at 01:46:51PM +0200, Jens Gustedt wrote:
>> Introduced by upstream commit 2a748853ca395c48ea75baa250f7cea6f0f23dbf,

confirmed through bisect and by reversion

>> fixed upstream with d62d421b071b08249361044d8e56c8b5c3ed6aa7.

confirmed

thanks!

Jens

--------------070202030805020201070109
Content-Type: text/x-vcard; charset=utf-8;
 name="Jens_Gustedt.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="Jens_Gustedt.vcf"

BEGIN:VCARD
VERSION:3.0
FN:Jens Gustedt
N:Gustedt;Jens;;;
ORG:INRIA Nancy Grand Est
NICKNAME:Jens
TITLE:directeur de recherche
URL:http://www.loria.fr/~gustedt/
TEL;fax:+33-3-83-27-83-19
TEL;cell:+33-651400183
TEL;work:+33-3-83-59-30-90
ADR;TYPE=3Dwork;CHARSET=3DUTF-8:;INRIA Nancy Grand Est;Bat B - AlGorille;=
Vand=C5=93uvre-l=C3=A8s-Nancy;;54200;France
EMAIL;PREF;internet:Jens.Gustedt@loria.fr
AGENT:BEGIN:VCARD\nVERSION:2.1\nFN:Isabelle Herlich\nN:Herlich\;Isabelle\=
;\;\;\nORG: INRIA\nTEL\;TYPE=3Dwork:+33-383-59-20-72\nEMAIL:Isabelle.Herl=
ich@loria.fr\nEND:VCARD
AGENT:BEGIN:VCARD\nVERSION:2.1\nFN\;CHARSET=3DUTF-8:Sylvie Musilli\nN\;CH=
ARSET=3DUTF-8:Musilli\;Sylvie\;\;\;\nORG: University\nTEL\;TYPE=3Dwork:+3=
3-383-95-85-72\nEMAIL:Sylvie.Musilli@loria.fr\nEND:VCARD
AGENT:BEGIN:VCARD\nVERSION:2.1\nFN:Antoinette Courier\nN:Courier\;Antoine=
tte\;\;\;\nORG: CNRS\nTEL\;TYPE=3Dwork:+33-383-59-20-09\nEMAIL:Antoinette=
=2ECourier@loria.fr\nEND:VCARD
END:VCARD

--------------070202030805020201070109--
