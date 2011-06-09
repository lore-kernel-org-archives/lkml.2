Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab1FIIsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 04:48:30 -0400
Received: from mx0.init-ka.de ([62.153.77.47]:52712 "EHLO gateway13.init-ka.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753802Ab1FIIs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:48:27 -0400
From: "Hornung, Michael" <mhornung@init-ka.de>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Thu, 9 Jun 2011 10:48:22 +0200
Subject: AW: Kernel > 2.6.30: PCI issue causes Kernel freeze at booting
Thread-Topic: Kernel > 2.6.30: PCI issue causes Kernel freeze at booting
Thread-Index: Acwgeh2QJSAruKWnRde7JyjU7aT41AGA8Xlg
Message-ID: <334319B2EBE0B144BAE1402B79D82DC5CE13B09E@srvpegasus>
References: <334319B2EBE0B144BAE1402B79D82DC5CE13B056@srvpegasus>
 <BANLkTimNSe5JjM2+_-XzS7D8XPeZrPL0oA@mail.gmail.com>
 <334319B2EBE0B144BAE1402B79D82DC5CE13B05A@srvpegasus>
 <BANLkTimX1KG-BZ98LH_NweOUOaUbQtZirg@mail.gmail.com>
 <BANLkTimrpnCdzRArjAn2NOZMu0Bhf6Pn8Q@mail.gmail.com>
 <334319B2EBE0B144BAE1402B79D82DC5CE13B07E@srvpegasus>
 <BANLkTikgg_4Xj2Z3q6pR+QJSxg6c6cQ32w@mail.gmail.com>
 <334319B2EBE0B144BAE1402B79D82DC5CE13B082@srvpegasus>
 <BANLkTikyq-vn1vLZi_ReccwLqm7joRHbwg@mail.gmail.com>
In-Reply-To: <BANLkTikyq-vn1vLZi_ReccwLqm7joRHbwg@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Jun 2011 08:48:24.0003 (UTC) FILETIME=[FDF1F130:01CC2681]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> I opened this bug report to make sure we don't lose this.  I don't
>>> know when or if this will be addressed, but your system is valuable as
>>> a real live test case that shows what we're doing wrong.
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=36462

>>> Bjorn

Hi Bjorn,

just for the record, the BIOS hack does only work for kernels obove 2.6.33 (2.6.33.14). Those below seem not to care about the PNP device nodes.

With best regards


Michael Hornung

------------------------------------------------------------
Michael Hornung
Hardware
Mobile Telematic and Fare Collection Systems

Phone +49-(0)721-6100-305
Fax +49-(0)721-6100-399
E-Mail mhornung@init-ka.de

INIT Innovative Informatikanwendungen
in Transport-, Verkehrs- und Leitsystemen GmbH 
Käppelestrasse 4-6
76131 Karlsruhe
Germany
http://www.init-ka.de  
 
Geschäftsführer:
Dr.-Ing. Gottfried Greschner, Dipl.-Inform. Achim Becker, Dipl.-Ing. (FH) Wolfgang Degen, Dipl.-Kfm. Dr. Jürgen Greschner
 
Amtsgericht Mannheim HRB 103679 . Internationale Registrierungen: 988055689MVA (Norwegen), FC027220 (UK)  
 
Vertraulichkeitshinweis:
Der Inhalt dieser E-Mail ist vertraulich zu behandeln. Das Schreiben ist nur zur Kenntnis des oben genannten Empfängers bestimmt. Wenn Sie nicht der richtige Adressat sind, informieren Sie bitte sofort den Absender und vernichten diese Nachricht. Unerlaubte Kopien sowie unbefugte Weitergabe sind nicht gestattet.
Bitte beachten Sie, dass durch diese E-Mail keine rechtsverbindlichen Willenserklärungen abgegeben werden.
 
Privacy Notice:
Content of this e-mail must be treated as strictly confidential. This writing is intended only for the knowledge of the above-mentioned addressee. If you are not the correct recipient please inform the sender immediately and permanently erase this message. Illegal copies as well as unauthorized passing is not permitted and strictly forbidden.
Please note that by sending this mail INIT does not make any commitment and is under no obligation.
